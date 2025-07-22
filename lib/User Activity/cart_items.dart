import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Models/cart_model.dart';
import '../Provider/cart_provider.dart';

class CartItems extends ConsumerWidget {
  final CartModel cart;
  const CartItems({super.key, required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CartProvider cp = ref.watch(cartService);

    Size size = MediaQuery.of(context).size;
    final finalPrice = num.parse(
      (cart.productData['price'] *
          (1 - cart.productData['discountPercentage'] / 100))
          .toStringAsFixed(2),
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 120,
      width: size.width / 1.1,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              CachedNetworkImage(
                imageUrl: cart.productData['image'],
                height: 120,
                width: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      cart.productData['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Color :"),
                        const SizedBox(width: 5),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: getColorFromName(cart.selectedColor),
                        ),
                        const SizedBox(width: 10),
                        const Text("Size :"),
                        Text(
                          cart.selectedSize,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text(
                          "\$$finalPrice",
                          style: const TextStyle(
                            color: Colors.pink,
                            fontSize: 22,
                            letterSpacing: -1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 45),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (cart.quantity > 1) {
                                  cp.reduceQuantity(cart.productId);
                                }
                              },
                              child: Container(
                                width: 25,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(7),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              cart.quantity.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                cp.addCart(
                                  cart.productId,
                                  cart.productData,
                                  cart.selectedColor,
                                  cart.selectedSize,
                                );
                              },
                              child: Container(
                                width: 25,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(7),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}