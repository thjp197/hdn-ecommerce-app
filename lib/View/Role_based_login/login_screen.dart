import 'package:flutter/material.dart';
import 'package:myecommerceapp/View/Role_based_login/Admin/Screen/admin_home_screen.dart';
import 'package:myecommerceapp/View/Role_based_login/User/app_main_screen.dart';
import 'package:myecommerceapp/View/Role_based_login/signup_screen.dart';
import 'package:myecommerceapp/Services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordHidden = true;
  bool isLoading = false; //to show loading spinner during
  //instance for AuthService for authentication logic
  final AuthService _authService = AuthService();

  void login()async {
    setState(() {
      isLoading = true;
    });

    //call login method from authservice with user inputs
    String? result = await _authService.login(
      email: emailController.text,
      password: passwordController.text,
    );
    setState(() {
      isLoading = false;
    });
    // Navigate based on the role or show the error message
    if(result == "Admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_)=> const AdminHomeScreen(),
        ),
      );
    } else if(result == "User") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_)=> const AppMainScreen(),
        ),
      );
    } else {
      //login failed: show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Signup Failed $result"
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.asset("asssets/login.jpg"),
                    const SizedBox(height: 20),

                    //input email
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder()
                      ),
                    ),
                    const SizedBox(height: 15),
                    //input password
                    TextField(
                      controller: passwordController,
                      decoration:  InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                          icon: Icon(
                            isPasswordHidden ?Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                      obscureText: isPasswordHidden,
                    ),
                    const SizedBox(height: 20),
                    //Login button
                    isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: login,
                        child: Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 18),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                            builder: (_)=> const SignupScreen(),
                          ),
                          );
                        },
                        child: const Text (
                          "Signup here",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              letterSpacing: -1
                        ),
                        ),
                      ),
                    ],)

                  ],
                ),
    ),
    ),
    );
  }
}