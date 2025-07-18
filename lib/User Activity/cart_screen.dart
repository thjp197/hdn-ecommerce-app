import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled2/User%20Activity/Provider/cart_provider.dart';
import '../Provider/cart_provider.dart';

// import thu vien chua color.dart, cart_provider
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cp = ref.watch(cartService);
    final carts = cp.carts.reversed.toList();
    return Scaffold(
      backgroundColor: fbackgroundColor1,
      appBar: AppBar(
        backgroundColor: fbackgroundColor1,
        elevation: 0,
        title:const Text(
          "My Cart",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: carts.isNotEmpty? ListView.builder(
            itemCount: carts.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(onTap: () {},
              ),
            );
          },):Center(child: Text("Your cart is empty!",style: TextStyle(color: Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.w500,),
          ),
          )
          ),
        ],
      )
    );
  }
}