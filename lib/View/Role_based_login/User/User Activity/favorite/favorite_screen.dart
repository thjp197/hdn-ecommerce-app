import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/Core/Common/Utils/colors.dart';
import 'package:e_commerce_app/Core/Provider/favorite_provider.dart';
import 'package:e_commerce_app/Views/Role_based_login/User/Screen/Items_detail_screen/Screen/items_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(favouriteProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: fbackgroundColor2,
      appBar: AppBar(
        backgroundColor: fbackgroundColor2,
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: userId == null
          ? const Center(child: Text("Please log in to view favorites"))
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("userFavorite")
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userFavorites = snapshot.data;
          if (userFavorites == null || !userFavorites.exists) {
            return const Center(child: Text("No favorites yet"));
          }

          final List<String> favoriteIds =
          List<String>.from(userFavorites.get('favorites') ?? []);

          if (favoriteIds.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }

          return FutureBuilder<List<DocumentSnapshot>>(
            future: Future.wait(
              favoriteIds.map((id) => FirebaseFirestore.instance
                  .collection("items")
                  .doc(id)
                  .get()),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final favoriteItems = snapshot.data!
                  .where((doc) =>
              doc.exists) // Filter out non-existing items
                  .toList();

              if (favoriteItems.isEmpty) {
                return const Center(child: Text("No favorites yet"));
              }

              return ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  final favoriteItem = favoriteItems[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemsDetailScreen(
                            productItems: favoriteItem,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        favoriteItem['image'],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20),
                                        child: Text(
                                          favoriteItem['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Text(
                                          "${favoriteItem['category']} Fashion"),
                                      Text(
                                        "\$${favoriteItem['price']}.00",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.pink,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 50,
                          right: 35,
                          child: GestureDetector(
                            onTap: () {
                              provider.toggleFavorite(favoriteItem);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
