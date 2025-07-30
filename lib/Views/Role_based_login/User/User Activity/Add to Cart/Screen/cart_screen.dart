import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecommerceapp/Core/Common/payment_method_list.dart';

import 'package:myecommerceapp/Core/Provider/cart_provider.dart';
import 'package:myecommerceapp/Core/Common//Utils/colors.dart';
import 'package:myecommerceapp/Widgets/show_snackbar.dart';
import 'package:myecommerceapp/Views/Role_based_login/User/User%20Activity/Add%20to%20Cart/Widgets/cart_items.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String? selectedPaymentMethodId;
  double? selectedPaymentBalance;
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cp = ref.watch(cartService);
    final carts = cp.carts.reversed.toList();
    return Scaffold(
      backgroundColor: fbackgroundColor1,
      appBar: AppBar(
        backgroundColor: fbackgroundColor1,
        elevation: 0,
        //  leading: Icon(),
        title: const Text(
          "My Cart",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: carts.isNotEmpty
                ? ListView.builder(
              itemCount: carts.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () {},
                    onLongPress: () {
                      cp.deleteCartItem(carts[index].productId);
                    },
                    child: CartItems(
                      cart: carts[index],
                    ),
                  ),
                );
              },
            )
                : Center(
              child: Text(
                "Your cart is empty!",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // For total cart summary
          if (carts.isNotEmpty) _buildSummarySection(context, cp)
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, CartProvider cp) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Expanded(child: DottedLine()),
              SizedBox(width: 10),
              Text(
                "\$4.99",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Total Order",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(child: DottedLine()),
              const SizedBox(width: 10),
              Text(
                "\$${(cp.totalCart()).toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 22,
                  letterSpacing: -1,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          const SizedBox(height: 40),
          MaterialButton(
            color: Colors.black,
            height: 70,
            minWidth: MediaQuery.of(context).size.width - 50,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              _showOrderConfirmationDialog(context, cp);
            },
            child: Text(
              "Pay \$${((cp.totalCart() + 4.99).toStringAsFixed(2))}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showOrderConfirmationDialog(BuildContext context, CartProvider cp) {
    String? addressError;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Confirm Your Order"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListBody(
                      children: cp.carts.map((cartItem) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${cartItem.productData['name']} x ${cartItem.quantity}")
                          ],
                        );
                      }).toList(),
                    ),
                    Text(
                        "Total Payable Price: \$${(cp.totalCart() + 4.99).toStringAsFixed(2)}"),
                    const SizedBox(height: 10),
                    const Text(
                      "Select Payment Method",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PaymentMethodList(
                      selectedPaymentMethodId: selectedPaymentMethodId,
                      selectedPaymentBalance: selectedPaymentBalance,
                      finalAmount: cp.totalCart() + 4.99,
                      onPaymentMethodSelected: (p0, p1) {
                        setDialogState(() {
                          selectedPaymentMethodId = p0;
                          selectedPaymentBalance = p1;
                        });
                      },
                    ),
                    // to add the address
                    const Text(
                      "Add your Delivery Address",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: "Enter your address",
                        errorText: addressError,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (selectedPaymentMethodId == null) {
                      showSnackBar(context, "Please select a payment method!");
                    } else if (selectedPaymentBalance! <
                        cp.totalCart() + 4.99) {
                      showSnackBar(context,
                          "Insufficient balance in selected payment method!");
                    } else if (addressController.text.length < 8) {
                      setDialogState(() {
                        addressError =
                        "Your address must be reflect your address identity";
                      });
                    } else {
                      _saveOrder(cp, context);
                    }
                  },
                  child: const Text("Confirm"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                )
              ],
            );
          });
        });
  }

  Future<void> _saveOrder(CartProvider cp, context) async {
    final userId =
        FirebaseAuth.instance.currentUser?.uid; // get user current id
    if (userId == null) {
      showSnackBar(context, "You need to be logged in to place an order.");
      return;
    }
    await cp.saveOrder(
      userId,
      context,
      selectedPaymentMethodId,
      cp.totalCart() + 4.99,
      addressController.text,
    );
    showSnackBar(context, "Order placed successfully!");
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const MyOrderScreen(),
    //   ),
    // );
  }
}