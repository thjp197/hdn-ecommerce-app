import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Total Order"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Orders").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No orders yet"),
              );
            }
            final orders = snapshot.data!.docs;

            return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  var order = orders[index];
                  return ListTile(
                    title: Text(
                        "Order ID:${order.id}\nTotal Price: \$${order['totalPrice']}"),
                    subtitle: Text(
                      "Delivery location: ${order["address"]}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(
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

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

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
                          "Product ID: ${item['productId']}",
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

