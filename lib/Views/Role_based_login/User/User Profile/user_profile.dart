import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecommerceapp/Core/Provider/cart_provider.dart';
import 'package:myecommerceapp/Core/Provider/favorite_provider.dart';
import 'package:myecommerceapp/Services/auth_service.dart';
import 'package:myecommerceapp/Views/Role_based_login/User/User%20Profile/Order/my_order_screen.dart';
import 'package:myecommerceapp/Views/Role_based_login/User/User%20Profile/Payment/payment_screen.dart';
import 'package:myecommerceapp/Views/Role_based_login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final AuthService _authService = AuthService();

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, //center
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      //current login user detail
                      SizedBox(
                        width: double.maxFinite,
                        //fetch the user data from firebase
                        child: StreamBuilder<DocumentSnapshot>(
                          stream:
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(userId)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Center(child: CircularProgressIndicator());
                            }
                            final user = snapshot.data!;
                            return Column(
                              children: [
                                const CircleAvatar(
                                  radius: 60,
                                  backgroundImage: CachedNetworkImageProvider(
                                    "https://www.pngarts.com/files/5/User-Avatar-Free-PNG-Image.png",
                                  ),
                                ),
                                Text(
                                  user['name'], //lay name tu firebase
                                  style: TextStyle(
                                    fontSize: 20,
                                    height: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user['email'],
                                  style: const TextStyle(height: 0.5),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyOrderScreen(),
                                ),
                              );
                            },
                            child: const ListTile(
                              leading: Icon(
                                Icons.change_circle_rounded,
                                size: 30,
                              ),
                              title: Text(
                                "Order",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaymentScreen(),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: Icon(Icons.payments, size: 30),
                              title: Text(
                                "Payment Method",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: const ListTile(
                              leading: Icon(Icons.info, size: 30),
                              title: Text(
                                "About Us",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _authService.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                              ref.invalidate(cartService);
                              ref.invalidate(favouriteProvider);
                            },
                            child: const ListTile(
                              leading: Icon(Icons.exit_to_app, size: 30),
                              title: Text(
                                "Log Out",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
