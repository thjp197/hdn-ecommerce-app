import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Services/auth_service.dart';
import '../../login_screen.dart';

AuthService _authService = AuthService();

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {

    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //current login user detail
              SizedBox(
                width: double.maxFinite,
                //fetch the user data from firebase
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .snapshots(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData || !snapshot.data!.exists){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final user = snapshot.data!;
                      return Column(
                        children: [
                          const CircleAvatar(
                            radius: 60,
                            backgroundImage: CachedNetworkImageProvider(
                                url),//paste link url (png) hinh user vao
                          ),
                          Text(
                            user['name'], //lay name tu firebase
                            style: TextStyle(
                                fontSize: 20,
                                height: 2,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            user['email'],
                            style: const TextStyle(height: 0.5),
                          )
                        ],
                      );
                    }),
              ),
              const SizedBox(height: 20),
              const Divider(),
              Column(children: [
                GestureDetector(
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
                  child: ListTile(
                    leading: Icon(
                      Icons.payments,
                      size: 30,
                    ),
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
                    leading: Icon(
                      Icons.info,
                      size: 30,
                    ),
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
                        builder: (_)=> const LoginScreen(),
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 30,
                    ),
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
    );
  }
}

//file user_app_main_screen.dart -> dong 18, ngay duoi const Scaffold sua thanh const UserProfile()
