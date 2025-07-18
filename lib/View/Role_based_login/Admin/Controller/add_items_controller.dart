import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myecommerceapp/View/Role_based_login/Admin/Model/add_items_model.dart';

final addItemProvider = StateNotifierProvider<AddItemNotifier, AddItemState>((
    ref) {
  return AddItemNotifier();
});

class AddItemNotifier extends StateNotifier<AddItemState> {
  AddItemNotifier() : super(AddItemState()) {
    // fetchCategory();
  }

  //for stroring the all the items on this collection
  final CollectionReference items =
  FirebaseFirestore.instance.collection("items");

  //for category
  final CollectionReference categoriesCollection =
  FirebaseFirestore.instance.collection("Category");

  //for image picker
  void pickImage() async {
    try {
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        state = state.copyWith(imagePath: pickedFile.path);
      }
    } catch (e) {
      // handle error
      throw Exception("Error saving item:$e");
    }
  }

  //to select the categoryItems
  void setSelectedCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  //for size
  void addSize(String size) {
    state = state.copyWith(sizes: [...state.sizes, size]);
  }

  void removeSize(String size) {
    state = state.copyWith(sizes: state.sizes.where((s) => s != size).toList());
  }

  //for color
  void addColor(String color) {
    state = state.copyWith(colors: [...state.colors, color]);
  }

  void removeColor(String color) {
    state =
        state.copyWith(colors: state.colors.where((c) => c != color).toList());
  }

  //for discount
  void toggleDiscount(bool? isDiscounted) {
    state = state.copyWith(isDiscounted: isDiscounted);
  }

  void setDiscountPercentage(String percentage) {
    state = state.copyWith(discountPercentage: percentage);
  }

  //to handle the loading indicator
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> fetchCategory() async {
    try{
     QuerySnapshot snapshot = await categoriesCollection.get();
     List<String> categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
     state = state.copyWith(categories:categories);
    } catch(e) {
      throw Exception('Error save item:$e');
    }
  }

  //upload and save items
  Future<void> uploadAndSaveItem(String name, String price) async{
    if(name.isEmpty || price.isEmpty ||
        state.imagePath == null || state.selectedCategory == null ||
        state.sizes.isEmpty || state.colors.isEmpty ||
        (state.isDiscounted && state.discountPercentage == null)) {
          throw Exception("Please fill all the field an upload an image.");
        }
    state = state.copyWith(isLoading: true);
    try{
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final reference = FirebaseStorage.instance.ref().child('image/$fileName');
      await reference.putFile(File(state.imagePath!));
      final imageUrl = await reference.getDownloadURL();

      //save item to firestore
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      await items.add({
        'name': name,
        'price':price,
        'image':imageUrl,
        'uploadedBy':uid,
        'category':state.selectedCategory,
        'size':state.sizes,
        'fcolor':state.colors,
        'isDiscounted':state.isDiscounted,
        'discountPercentage': state.isDiscounted? int.tryParse(state.discountPercentage!):0,
      });
      //Reset state after successfully upload data
      state = AddItemState();

    }catch (e) {
       throw Exception("Error save item:$e");
    }finally {
      state = state.copyWith(isLoading: false);
    }
  }
}