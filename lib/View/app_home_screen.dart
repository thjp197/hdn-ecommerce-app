import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myecommerceapp/Models/category_model.dart';
import 'package:myecommerceapp/Models/model.dart';
import 'package:myecommerceapp/Utils/colors.dart';
import 'package:myecommerceapp/View/items_detail_screen.dart';
import 'package:myecommerceapp/Widgets/banner.dart';
import 'package:myecommerceapp/Widgets/curated_items.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("asssets/logo.png", height: 55),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Iconsax.shopping_bag, size: 28),
                      Positioned(
                        right: -3,
                        top: -5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "3",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //for banner
            const MyBanner(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shop By Category",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            //for category
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  category.length,
                      (index) =>
                      InkWell(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: fbackgroundColor1,
                                backgroundImage: AssetImage(
                                    category[index].image),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(category[index].name),
                          ],
                        ),
                      ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Curated For You",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            //for curated items
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(fashionEcommerceApp.length, (index) {
                  final eCommerceItems = fashionEcommerceApp[index];
                  return Padding(
                    padding:
                    index == 0
                        ? const EdgeInsets.symmetric(horizontal: 20)
                        : const EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) =>
                              ItemsDetailScreen(
                                eCommerceApp: eCommerceItems,
                              ),
                          ),
                        );
                      },
                      child: CuratedItems(
                        eCommerceItems: eCommerceItems,
                        size: size,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
