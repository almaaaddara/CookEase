import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mama_recipe/screen/detail_recipe.dart';
import 'package:mama_recipe/utils/color_theme.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  Future<List<Map<String, dynamic>>> fetchBookmarkedRecipes() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final favorites = await FirebaseFirestore.instance
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> recipes = [];

    for (var favorite in favorites.docs) {
      final recipeId = favorite['recipeId'];
      final recipeSnapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();

      if (recipeSnapshot.exists) {
        recipes.add(recipeSnapshot.data()!);
      }
    }

    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bookmarks'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBookmarkedRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final favoriteFoods = snapshot.data ?? [];

          if (favoriteFoods.isEmpty) {
            return const Center(
              child: Text('No bookmarks yet.'),
            );
          }

          return ListView.builder(
            itemCount: favoriteFoods.length,
            itemBuilder: (context, index) {
              final recipe = favoriteFoods[index];
              return GestureDetector(
                onTap: () {
                  print("data resep ${recipe}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailPage(
                        recipeId: recipe[
                            'id'], // Mengirimkan ID resep ke halaman detail
                      ),
                    ),
                  );
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar resep
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                recipe['image'] ?? 'assets/default.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Detail resep
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  // CircleAvatar(
                                  //   radius: 13,
                                  //   backgroundImage: NetworkImage(
                                  //     recipe['author']['profileImage'] ??
                                  //         'assets/default_avatar.jpg',
                                  //   ),
                                  // ),
                                  // const SizedBox(width: 10),
                                  Text(
                                    recipe['username'],
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColor.textSecondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  const Icon(Icons.restaurant,
                                      size: 14, color: Colors.black),
                                  Text(
                                    " ${recipe['servings']} Portion",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColor.textSecondary),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.timer,
                                      size: 14, color: Colors.black),
                                  Text(
                                    " ${recipe['cookTime']} Min",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColor.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
