class SubCategory {
  final String name, image;

  SubCategory({required this.name, required this.image});
}

List<SubCategory> subcategory = [
  SubCategory(
      name: "Bags",
      image: "asssets/category_image/sub_category/image1.png"
  ),
  SubCategory(
      name: "Wallets",
      image: "asssets/category_image/sub_category/image2.png"
  ),
  SubCategory(
      name: "Footwear",
      image: "asssets/category_image/sub_category/image3.png"
  ),
  SubCategory(
      name: "Clothes",
      image: "asssets/category_image/sub_category/image4.png"
  ),
  SubCategory(
      name: "Watch",
      image: "asssets/category_image/sub_category/image5.png"
  ),
  SubCategory(
      name: "Makeup",
      image: "asssets/category_image/sub_category/image6.png"
  ),
];
List<String> filterCategory = [
  "Filter",
  "Ratings",
  "Size",
  "Color",
  "Price",
  "Brand",
];