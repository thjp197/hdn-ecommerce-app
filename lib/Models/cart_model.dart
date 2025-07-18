class CartModel {
  final String productId;
  final Map<String, dynamic> productData;
  int quantity;
  final String selectedColor;
  final String selectedSize;


  CartModel({
   required this.productId,
   required this.productData,
   required this.quantity,
   required this.selectedColor,
   required this.selectedSize,
});
}