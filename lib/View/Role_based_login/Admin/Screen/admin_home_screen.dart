import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecommerceapp/Services/auth_service.dart';
import 'package:myecommerceapp/View/Role_based_login/Admin/Screen/add_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myecommerceapp/View/Role_based_login/login_screen.dart';

final AuthService _authService = AuthService();

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  final CollectionReference items = FirebaseFirestore.instance.collection(
    "items",
  );
  String? selectedCategory;
  List<String> categories = [];

  @override
  void initState() {
    fetchCategories();
    super.initState();
  }

  Future<void> fetchCategories() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Category").get();
    setState(() {
      categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Your Upload Items",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // const Spacer(),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.receipt_long),
                      ),
                      const Positioned(
                        top: 6,
                        right: 8,
                        child: const CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.red,
                          child: Center(
                            child: Text(
                              "o",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //signOut
                  GestureDetector(
                    onTap: () {
                      _authService.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      // ref.invalidate()
                    },
                    child: const Icon(Icons.exit_to_app),
                  ),

                  DropdownButton<String>(
                    items:
                        categories.map((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                    icon: const Icon(Icons.tune),
                    underline: const SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream:
                      items
                          .where("uploadedBy", isEqualTo: uid)
                          .where('category', isEqualTo: selectedCategory)
                          .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Error loading items."));
                    }
                    final documents = snapshot.data?.docs ?? [];
                    if (documents.isEmpty) {
                      return const Center(child: Text("No items uploaded."));
                    }
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final items =
                            documents[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 2,
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: items['image'],
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                items['name'] ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        items['price'] != null
                                            ? "\$${items['price']}.00"
                                            : "N/A",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          letterSpacing: -1,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text("${items['category'] ?? "N/A"}"),
                                      // const SizedBox(width: 5),
                                      // Text("${items['category'] ?? "N/A"}"),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddItems()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
