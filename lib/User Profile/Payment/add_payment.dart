
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../Widget/my_button.dart';
import '../../Widget/show_snackbar.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(
      mask: "**** **** **** ****", // defines the pattern
      filter: {"*": RegExp(r'[0-9]')} // allows only digits
      );
  double balance = 0.0;
  String? selectedPaymentSystem;
  Map<String, dynamic>? selectedPaymentSystemData;
  final _formKey = GlobalKey<FormState>();
  Future<List<Map<String, dynamic>>> fetchPaymentSystems() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("payment_methods").get();
    return snapshot.docs
        .map((doc) => {
              'name': doc['name'],
              'image': doc['image'],
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Payment Method"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FutureBuilder(
                    future: fetchPaymentSystems(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No payment systems available");
                      }
                      return DropdownButton<String>(
                          elevation: 2,
                          value: selectedPaymentSystem,
                          hint: const Text("Select Payment System"),
                          items: snapshot.data!.map((system) {
                            return DropdownMenuItem<String>(
                                value: system['name'],
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: system['image'],
                                      width: 30,
                                      height: 30,
                                      errorWidget:
                                          (context, stackTrace, error) =>
                                              const Icon(Icons.error),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(system['name'])
                                  ],
                                ));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentSystem = value;
                              selectedPaymentSystemData = snapshot.data!
                                  .firstWhere(
                                      (system) => system['name'] == value);
                            });
                          });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _userNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: "Card Holder Name",
                      hintText: "eg.John Doe",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return "Provide your full name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Card Number",
                      hintText: "eg.1230 4561 3454 8765",
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [maskFormatter],
                    validator: (value) {
                      if (value == null ||
                          value.replaceAll(' ', '').length != 16) {
                        return "Card number must be exactly 16 digits";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _balanceController,
                    decoration: const InputDecoration(
                        labelText: "Balance",
                        prefixText: "\$",
                        hintText: "40",
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        balance = double.tryParse(value) ?? 0.0,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTab: () => addPaymentMethod(),
                    buttonText: "Add Payment Method",
                  )
                ],
              )),
        ),
      ),
    );
  }
  void addPaymentMethod() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && selectedPaymentSystemData != null) {
      final paymentCollection =
          FirebaseFirestore.instance.collection("User Payment Method");
      final existingMethods = await paymentCollection
          .where('userId', isEqualTo: userId)
          .where("paymentSystem", isEqualTo: selectedPaymentSystemData!['name'])
          .get();
      if (existingMethods.docs.isNotEmpty) {
        showSnackBar(context, "You  have already added this payment method!");
        return; 
      }
      await paymentCollection.add({
        'userName': _userNameController.text.trim(),
        'cardNumber': _cardNumberController.text.trim(),
        'balance': balance,
        'userId': userId,
        'paymentSystem': selectedPaymentSystemData!['name'],
        'image': selectedPaymentSystemData!['image'],
      });
      showSnackBar(context, "Payment method successfully added!");
      Navigator.pop(context);
    } else {
      showSnackBar(context, "Failed to add payment method. Plaease try again.");
    }
  }
}
