import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecommerceapp/Core/Common/Utils/colors.dart';
import 'package:myecommerceapp/Core/Provider/favorite_provider.dart';

class CuratedItems extends ConsumerWidget {
  final DocumentSnapshot<Object?> eCommerceItems;
  final Size size;

  const CuratedItems({
    super.key,
    required this.eCommerceItems,
    required this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(favouriteProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: eCommerceItems.id,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: fbackgroundColor2,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(eCommerceItems['image']),
              ),
            ),
            height: size.height * 0.25,
            width: size.width * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.topRight,
                child:
                CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      provider.isExist(eCommerceItems)
                          ? Colors.white
                          : Colors.black26,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(favouriteProvider)
                          .toggleFavorite(eCommerceItems);
                    },
                    child: Icon(
                      provider.isExist(eCommerceItems)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          provider.isExist(eCommerceItems)
                              ? Colors.red
                              : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Text(
              "H&M",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black26,
              ),
            ),
            SizedBox(width: 5),
            Icon(Icons.star, color: Colors.amber, size: 17),
            Text("${Random().nextInt(2) + 3}.${Random().nextInt(5) + 4}"),
            Text(
              "(${Random().nextInt(300) + 25})",
              style: const TextStyle(color: Colors.black26),
            ),
          ],
        ),
        SizedBox(
          width: size.width * 0.5,
          child: Text(
            eCommerceItems['name'] ?? "N/A",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
        Row(
          children: [
            // Text(
            //   "\$${(eCommerceItems['price'] * (1 - eCommerceItems['discountPercentage'] / 100)).toStringAsFixed(2)}",
            //   style: const TextStyle(
            //     fontWeight: FontWeight.w600,
            //     fontSize: 18,
            //     color: Colors.pink,
            //     height: 1.5,
            //   ),
            // ),
            Text(
              "\$${_calculateDiscountedPrice(eCommerceItems['price'], eCommerceItems['discountPercentage'])}",
              // FIXED: sử dụng helper function
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.pink,
                height: 1.5,
              ),
            ),
            const SizedBox(width: 5),
            if (eCommerceItems['isDiscounted'] == true)
              // Text(
              //   "\$${eCommerceItems['price']}.00", //+255
              //   style: const TextStyle(
              //     color: Colors.black26,
              //     decoration: TextDecoration.lineThrough,
              //     decorationColor: Colors.black26,
              //   ),
              // ),
              Text(
                "\$${_parsePrice(eCommerceItems['price']).toStringAsFixed(2)}",
                // FIXED: sử dụng _parsePrice cho String
                style: const TextStyle(
                  color: Colors.black26,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.black26,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// Helper function để chuyển đổi price (String) sang double
double _parsePrice(String priceString) {
  return double.tryParse(priceString) ?? 0.0;
}

// Helper function để tính giá sau giảm giá
// price: String, discountPercentage: number
String _calculateDiscountedPrice(String price, num discountPercentage) {
  double priceDouble = _parsePrice(price);
  double discountDouble = discountPercentage.toDouble();
  double discountedPrice = priceDouble * (1 - discountDouble / 100);
  return discountedPrice.toStringAsFixed(2);
}
