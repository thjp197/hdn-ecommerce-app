// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favouriteProvider =
ChangeNotifierProvider<FavoriteProvider>((ref) => FavoriteProvider());

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get favorites => _favoriteIds;

  void reset() {
    _favoriteIds = [];
    notifyListeners();
  }

  final userId =
      FirebaseAuth.instance.currentUser?.uid; // Get current user's ID
  FavoriteProvider() {
    loadFavorites();
  }
  // toggle favorites states
  void toggleFavorite(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _removeFavorite(productId); // remove from favorite
    } else {
      _favoriteIds.add(productId);
      await _addFavorite(productId); // add to favorite
    }
    notifyListeners();
  }

  // check if a product is favorited
  bool isExist(DocumentSnapshot prouct) {
    return _favoriteIds.contains(prouct.id);
  }

  // add favorites to firestore
  Future<void> _addFavorite(String productId) async {
    try {
      if (userId == null) return;

      final userRef = _firestore.collection("userFavorite").doc(userId);

      await userRef.set({
        'favorites': FieldValue.arrayUnion([productId]),
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  // Remove favorite from firestore
  Future<void> _removeFavorite(String productId) async {
    try {
      if (userId == null) return;

      final userRef = _firestore.collection("userFavorite").doc(userId);
      await userRef.update({
        'favorites': FieldValue.arrayRemove([productId]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // load favories from firestore (store favorite or not)
  Future<void> loadFavorites() async {
    try {
      if (userId == null) return;

      final userDoc =
      await _firestore.collection("userFavorite").doc(userId).get();

      if (userDoc.exists) {
        _favoriteIds = List<String>.from(userDoc.get('favorites') ?? []);
      } else {
        _favoriteIds = [];
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}
