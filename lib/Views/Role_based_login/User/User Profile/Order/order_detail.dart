import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserOrderDetail extends StatelessWidget {
  final String orderId;
  const UserOrderDetail({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: false,
        title: const Text("Order Details"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("Orders")
              .doc(orderId)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var orders = snapshot.data!;
            var items = orders['items'] as List;
            if (items.isEmpty) {
              return const Center(
                child: Text("No orders found."),
              );
            }
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${item['name']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Quantity: ${item['quantity']}, Color: ${item['selectedColor']}, Size: ${item['selectedSize']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Price : \$${item['price'] ?? 0}, Status : Pending",
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  );
                });
          }),
    );
  }
}