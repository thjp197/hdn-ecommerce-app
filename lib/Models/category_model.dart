class Category {
  final String name, image;

  Category({required this.name, required this.image});
}

List<Category> category = [
  Category(
      name: "Women",
      image: "asssets/women.png",
  ),
  Category(
    name: "Men",
    image: "asssets/men.png",
  ),
  Category(
    name: "Teens",
    image: "asssets/teen.png",
  ),
  Category(
    name: "Kids",
    image: "asssets/kids.png",
  ),
  Category(
    name: "Baby",
    image: "asssets/baby.png",
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