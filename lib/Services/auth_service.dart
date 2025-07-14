// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<String?> signup({
//     required String name,
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     try {
//       // sign in user using FB authentication with email and password
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//             email: email.trim(),
//             password: password.trim(),
//         );
//
//       //save additional user data in firestore(name, role, email)
//       await _firestore
//           .collection("user")
//           .doc(userCredential.user!.uid)
//           .set({
//           'name':name.trim(),
//           "email":email.trim(),
//            "role":role.trim(), //role determines if user is admin or user
//           });
//           return null;// success no error message
//     } catch (e) {
//       return e.toString(); // error : return the exception message
//     }
//   }
//
//   //func to handle user login
//   Future<String?> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       // sign in user using FB authentication wil email and pass
//       UserCredential userCredential =
//       await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password.trim(),
//       );
//
//       //fetching the user's role from firestore to determinde access level
//       DocumentSnapshot userDoc = await _firestore
//           .collection("users")
//           .doc(userCredential.user!.uid)
//           .get();
//       return userDoc['role'];// return the user's role (admin/user)
//     } catch (e) {
//       return e.toString(); // error : return the exception message
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Đăng ký người dùng
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Lưu thông tin bổ sung vào Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'role': role.trim(),
      });

      return null; // thành công
    } on FirebaseAuthException catch (e) {
      return e.message; // ✅ đúng kiểu Firebase
    } catch (e) {
      return 'Unexpected error: ${e.toString()}'; // fallback nếu là lỗi khác
    }
  }

  // Hàm đăng nhập
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Lấy vai trò người dùng
      //     DocumentSnapshot userDoc = await _firestore
      //         .collection("users")
      //         .doc(userCredential.user!.uid)
      //         .get();
      //
      //     return userDoc['role'];
      //   } on FirebaseAuthException
      //   catch (e) {
      //     return e.message;
      //   } catch (e) {
      //     return 'Unexpected error: ${e.toString()}';
      //   }
      // }
      DocumentSnapshot userDoc = await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();
      return userDoc['role']; // return the user's role (admin/user)
    } catch (e) {
      return e.toString(); // error : return the exception message
    }
  }
  //for user logOut
  signOut() async {
    _auth.signOut();
  }
}


