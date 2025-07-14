import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myecommerceapp/View/Role_based_login/Admin/Screen/admin_home_screen.dart';
import 'package:myecommerceapp/View/Role_based_login/User/app_main_screen.dart';
import 'package:myecommerceapp/View/Role_based_login/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthStateHandler(),
      ),
    );
  }
}

class AuthStateHandler extends StatefulWidget {
  const AuthStateHandler({super.key});

  @override
  State<AuthStateHandler> createState() => _AuthStateHandlerState();
}

class _AuthStateHandlerState extends State<AuthStateHandler> {
  User? _currentUser;
  String? _userRole;

  @override
  void initState() {
    _initializeAuthState();
    super.initState();
  }

  void _initializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return; //Prevent setState if the widget is disposed
      setState(() {
        _currentUser = user;
      });
      if (user != null) {
        final userDoc =
            await FirebaseFirestore.instance
                .collection(
                  "users",
                ) //same collection that we have created during signup
                .doc(user.uid)
                .get();
        if (!mounted) return; //Prevent setState if the widget is disposed
        if (userDoc.exists) {
          setState(() {
            _userRole = userDoc['role'];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const LoginScreen();
    }
    if (_userRole == null) {
      // show a loading scaffold
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    //for keep user login
    return _userRole == "Admin" ? AdminHomeScreen() : AppMainScreen();
  }
}
