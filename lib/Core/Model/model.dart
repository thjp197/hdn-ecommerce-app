import 'package:flutter/material.dart';

class AppModel {
  final String name, image, description, category;
  final double rating;
  final int review, price;
  List<Color> fcolor;
  List<String> size;
  bool isCheck;

  AppModel({
    required this.name,
    required this.image,
    required this.rating,
    required this.price,
    required this.review,
    required this.fcolor,
    required this.size,
    required this.description,
    required this.isCheck,
    required this.category,
  });
}

List<AppModel> fashionEcommerceApp = [
  //id 1
  AppModel(
    name: "Oversized Fit Printed Mesh T_shirt",
    rating: 4.9,
    image: "asssets/category_image/image23.png",
    price: 300,
    review: 136,
    isCheck: true,
    category: "Women",
    fcolor: [Colors.black, Colors.blue, Colors.blue[100]!],
    size: ["XS", "S", "M"],
    description: "",
  ),
  //id 2
  AppModel(
    name: "Slim Fit Cotton Shirt",
    rating: 4.2,
    image: "asssets/category_image/image24.png",
    price: 250,
    review: 89,
    isCheck: true,
    category: "Men",
    fcolor: [Colors.grey, Colors.blueGrey, Colors.white],
    size: ["M", "L", "XL"],
    description: "",
  ),
  //id 3
  AppModel(
    name: "Casual Hoodie",
    rating: 4.7,
    image: "asssets/category_image/image25.png",
    price: 420,
    review: 112,
    isCheck:  true,
    category: "Teen",
    fcolor: [Colors.red, Colors.orange, Colors.yellow],
    size: ["S", "M", "L"],
    description: "",
  ),
  //id 4
  AppModel(
    name: "Denim Jeans",
    rating: 4.0,
    image: "asssets/category_image/image26.png",
    price: 350,
    review: 77,
    isCheck:  true,
    category: "Men",
    fcolor: [Colors.blue, Colors.indigo, Colors.black],
    size: ["M", "L", "XL"],
    description: "",
  ),
  //id 5
  AppModel(
    name: "Printed Kids Tee",
    rating: 4.5,
    image: "asssets/category_image/image27.png",
    price: 180,
    review: 66,
    isCheck:  true,
    category: "Kids",
    fcolor: [Colors.green, Colors.yellow, Colors.orange],
    size: ["XS", "S", "M"],
    description: "",
  ),
  //id 6
  AppModel(
    name: "Baby Romper Set",
    rating: 4.8,
    image: "asssets/category_image/image28.png",
    price: 120,
    review: 40,
    isCheck: true,
    category: "Baby",
    fcolor: [Colors.pink, Colors.white, Colors.lime],
    size: ["3M", "6M", "12M"],
    description: "",
  ),
  //id 7
  AppModel(
    name: "Floral Summer Dress",
    rating: 4.9,
    image: "asssets/category_image/image29.png",
    price: 200,
    review: 145,
    isCheck: true,
    category: "Women",
    fcolor: [Colors.purple, Colors.pink, Colors.deepPurple[100]!],
    size: ["S", "M", "L"],
    description: "",
  ),
  //id 8
  AppModel(
    name: "Graphic Teen Tee",
    rating: 4.3,
    image: "asssets/category_image/image30.png",
    price: 210,
    review: 99,
    isCheck: true,
    category: "Teen",
    fcolor: [Colors.black, Colors.blueGrey, Colors.grey],
    size: ["S", "M", "L"],
    description: "",
  ),
  //id 9
  AppModel(
    name: "Boys Track Pants",
    rating: 4.1,
    image: "asssets/category_image/image31.png",
    price: 230,
    review: 70,
    isCheck: true,
    category: "Kids",
    fcolor: [Colors.blue, Colors.teal, Colors.cyan],
    size: ["XS", "S", "M"],
    description: "",
  ),
  //id 10
  AppModel(
    name: "Formal Shirt",
    rating: 4.6,
    image: "asssets/category_image/image32.png",
    price: 330,
    review: 101,
    isCheck: true,
    category: "Men",
    fcolor: [Colors.white, Colors.grey, Colors.black],
    size: ["M", "L", "XL"],
    description: "",
  ),
  //id 11
  AppModel(
    name: "Women’s dress pants",
    rating: 4.4,
    image: "asssets/category_image/image33.png",
    price: 310,
    review: 108,
    isCheck: true,
    category: "Women",
    fcolor: [Colors.red, Colors.black, Colors.white],
    size: ["S", "M", "L"],
    description: "",
  ),
  //id 12
  AppModel(
    name: "Toddler T-shirt Pack",
    rating: 4.7,
    image: "asssets/category_image/image34.png",
    price: 140,
    review: 59,
    isCheck: true,
    category: "Baby",
    fcolor: [Colors.pinkAccent, Colors.orangeAccent, Colors.amber],
    size: ["3M", "6M", "12M"],
    description: "",
  ),
  //id 13
  AppModel(
    name: "Loose Fit Hoodie",
    rating: 4.5,
    image: "asssets/category_image/image35.png",
    price: 420,
    review: 150,
    isCheck: true,
    category: "Teen",
    fcolor: [Colors.greenAccent, Colors.grey, Colors.black],
    size: ["M", "L", "XL"],
    description: "",
  ),
  //id 14
  AppModel(
    name: "Boys Polo Shirt",
    rating: 4.3,
    image: "asssets/category_image/image36.png",
    price: 220,
    review: 83,
    isCheck: true,
    category: "Kids",
    fcolor: [Colors.red, Colors.white, Colors.blue],
    size: ["XS", "S", "M"],
    description: "",
  ),
  //id 15
  AppModel(
    name: "Women's Tunic Top",
    rating: 4.2,
    image: "asssets/category_image/image37.png",
    price: 340,
    review: 95,
    isCheck: true,
    category: "Women",
    fcolor: [Colors.purple, Colors.deepOrange, Colors.grey],
    size: ["S", "M", "L"],
    description: "",
  ),
  //id 16
  AppModel(
    name: "Men’s Cotton Shorts",
    rating: 4.1,
    image: "asssets/category_image/image38.png",
    price: 280,
    review: 78,
    isCheck: true,
    category: "Men",
    fcolor: [Colors.blueGrey, Colors.brown, Colors.black],
    size: ["M", "L", "XL"],
    description: "",
  ),
  //id 17
  AppModel(
    name: "Teen Oversized Tee",
    rating: 4.6,
    image: "asssets/category_image/image39.png",
    price: 260,
    review: 88,
    isCheck: true,
    category: "Teen",
    fcolor: [Colors.black, Colors.deepPurple, Colors.indigo],
    size: ["S", "M", "L"],
    description: "",
  ),
  //id 18
  AppModel(
    name: "Kids Shorts Combo",
    rating: 4.0,
    image: "asssets/category_image/image40.png",
    price: 200,
    review: 62,
    isCheck: true,
    category: "Kids",
    fcolor: [Colors.lime, Colors.teal, Colors.green],
    size: ["XS", "S", "M"],
    description: "",
  ),
  //id 19
  AppModel(
    name: "Baby Cotton Suit",
    rating: 4.9,
    image: "asssets/category_image/image41.png",
    price: 160,
    review: 47,
    isCheck: true,
    category: "Baby",
    fcolor: [Colors.white, Colors.pinkAccent, Colors.cyan],
    size: ["3M", "6M", "12M"],
    description: "",
  ),
  //id 20
  AppModel(
    name: "Men's Tracksuit",
    rating: 4.3,
    image: "asssets/category_image/image42.png",
    price: 390,
    review: 134,
    isCheck: true,
    category: "Men",
    fcolor: [Colors.black, Colors.grey, Colors.green],
    size: ["L", "XL", "XXL"],
    description: "",
  ),
  //id 21
  AppModel(
    name: "Women's Blazer",
    rating: 4.8,
    image: "asssets/category_image/image43.png",
    price: 520,
    review: 198,
    isCheck: true,
    category: "Women",
    fcolor: [Colors.grey, Colors.white, Colors.black],
    size: ["S", "M", "L"],
    description: "",
  ),
];


const myDescription1 = "Elevate your casual wardrobe with our";
const myDescription2 = " .Crafted from premium cotton for maximum comfort, this relaxed-fit tee feature";
