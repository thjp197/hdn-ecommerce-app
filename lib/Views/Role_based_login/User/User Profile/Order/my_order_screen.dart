import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myecommerceapp/Views/Role_based_login/User/User%20Profile/Order/order_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: false,
        title: const Text("Total Order"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where("userId", isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final orders = snapshot.data!.docs;
            if (orders.isEmpty) {
              return const Center(
                child: Text("No orders found."),
              );
            }
            return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  var order = orders[index];
                  return ListTile(
                    title: Text("Order ID:${order.id}"),
                    subtitle: Text("Total Price: \$${order['totalPrice']}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserOrderDetail(
                            orderId: order.id,
                          ),
                        ),
                      );
                    },
                  );
                });
          }),
    );
  }
}
