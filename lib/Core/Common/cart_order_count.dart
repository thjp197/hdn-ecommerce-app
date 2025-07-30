import 'package:myecommerceapp/Core/Provider/cart_provider.dart';
import 'package:myecommerceapp/Views/Role_based_login/User/User%20Activity/Add%20to%20Cart/Screen/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class CartOrderCount extends ConsumerWidget {
  const CartOrderCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CartProvider cp = ref.watch(cartService);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(
          Iconsax.shopping_bag,
          size: 28,
        ),
        cp.carts.isNotEmpty
            ? Positioned(
          right: -3,
          top: -5,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child:  Center(
                child: Text(
                  cp.carts.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        )
            : const SizedBox()
      ],
    );
  }
}
