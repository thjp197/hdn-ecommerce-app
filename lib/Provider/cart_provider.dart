import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/cart_model.dart';

final cartService = ChangeNotifierProvider<CartProvider>((ref)=>CartProvider());

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];
  List<CartModel> get carts => _carts;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void reset() {
    _carts = [];
    notifyListeners();
  }

  final userId = FirebaseAuth.instance.currentUser?.uid;
  set carts(List<CartModel> carts) {
    _carts = carts;
    notifyListeners();
  }
  Future<void> addCart(String productId, Map<String, dynamic> productData, String selectedColor, String selectedSize) async {
    int index = _carts.indexWhere((elements) => elements.productId == productId);
    if (index != -1) {
      var existingItem = _carts[index];
      _carts[index] = CartModel(productId: productId, productData: productData, quantity: existingItem.quantity + 1, selectedColor: selectedColor, selectedSize: selectedSize);
      await _updateCartInFirebase(productId, _carts[index].quantity);
    } else {
      _carts.add(CartModel(productId: productId, productData: productData, quantity: 1, selectedColor: selectedColor, selectedSize: selectedSize),);
      await _firestore.collection("userCart").doc(productId).set({'productData': productData, "Quantity": 1, "selectedColor": selectedColor, "selectedSize": selectedSize, "uid": userId,});
    }
    notifyListeners();
  }
  // increase quantity
  Future<void> addQuantity(String productId) async {
    int index = _carts.indexWhere((element) => element.productId == productId);
    _carts[index].quantity += 1;
    await _updateCartInFirebase(productId, _carts[index].quantity);
    notifyListeners();
  }
  // decrease or remove quantity
  Future<void> decreaseQuantity(String productId) async {
    int index = _carts.indexWhere((element) => element.productId == productId);
    _carts[index].quantity -= 1;
    if(_carts[index].quantity <= 0) {
      _carts.removeAt(index);
      await _firestore.collection("userCart").doc(productId).delete();
    } else {
      await _updateCartInFirebase(productId, _carts[index].quantity);
    }
    notifyListeners();
  }
  // check if product exist in cart
  bool productExist(String productId) {
    return _carts.any((element)=> element.productId == productId);
  }
  
  // calculate total cart value
  double totalCart() {
    double total = 0;
    for ( var i = 0; i < _carts.length; i++) {
      final finalPrice = num.parse((_carts[i].productData['price']*(1 - _carts[i].productData['discountPercentage']/100)).toStringAsFixed(2));
      total += _carts[i].quantity * (finalPrice);
    }
    return total;
  }
  // load cart items from firebase
  Future<void> loadCartItems() async {
    try{
      QuerySnapshot snapshot = await _firestore.collection("userCart").where("uid", isEqualTo: userId).get();
      _carts = snapshot.docs.map((doc){
        final data = doc.data() as Map<String, dynamic>;
        return CartModel(productId: doc.id, productData: data['productData'], quantity: data['quantity'], selectedColor: data['selectedColor'], selectedSize: data['selectedSize']);
      }).toList();
    } catch(e) {
      print(e.toString());
    }
  }
  //save orderList in firestore
  
  //remove cartItems from firestore
  Future<void> deleteCartItem(String productId) async {
    int index = _carts.indexWhere((element) => element.productId == productId);
    if(index != -1) {
      _carts.removeAt(index); //remove item from local cart
      await _firestore.collection("userCart").doc(productId).delete(); //remove from firestore
      notifyListeners();
    }
  }

  Future<void>_updateCartInFirebase(String productId,int quantity) async {
    try {
      await _firestore.collection("userCart").doc(productId).update({"quantity":quantity,});
    } catch(e) {
      print(e.toString());
    }
  }
}