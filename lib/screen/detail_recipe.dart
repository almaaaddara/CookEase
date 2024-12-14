import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mama_recipe/models/food.dart';
import 'package:mama_recipe/services/history.dart';
import 'package:mama_recipe/utils/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mama_recipe/services/recipe.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool isBookmarked = false;
  final RecipeService recipeService = RecipeService();
  final HistoryService historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    // Cek status bookmark saat halaman dibuka
    checkIfBookmarked();
    // Tambahkan ke history
    historyService.updateHistory(widget.recipeId);
  }

  // Fungsi untuk memeriksa status bookmark
  void checkIfBookmarked() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final favoriteRef = FirebaseFirestore.instance.collection('favorites');

    favoriteRef
        .where('userId', isEqualTo: userId)
        .where('recipeId', isEqualTo: widget.recipeId)
        .get()
        .then((querySnapshot) {
      setState(() {
        isBookmarked = querySnapshot.docs.isNotEmpty;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  // Fungsi untuk toggle bookmark
  void toggleBookmark() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final favoriteRef = FirebaseFirestore.instance.collection('favorites');

    favoriteRef
        .where('userId', isEqualTo: userId)
        .where('recipeId', isEqualTo: widget.recipeId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        // Jika belum ada, tambahkan ke favorit
        favoriteRef.add({
          'userId': userId,
          'recipeId': widget.recipeId,
          'createdAt': FieldValue.serverTimestamp(),
        }).then((_) {
          setState(() {
            isBookmarked = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Recipe added to favorites!'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  toggleBookmark();
                },
              ),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        });
      } else {
        // Jika sudah ada, hapus dari favorit
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
        setState(() {
          isBookmarked = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Recipe removed from favorites!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                toggleBookmark();
              },
            ),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Detail'),
      ),
      body: FutureBuilder<Recipe>(
        future: recipeService
            .getDetail(widget.recipeId), // Get data berdasarkan ID resep
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Recipe not found'));
          }

          final recipe = snapshot.data!;

          print("Recipe Data: $recipe");

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar resep
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(recipe.image ?? 'assets/default.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Title resep
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Cook Time dan Servings - Bookmark
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 18),
                          const SizedBox(width: 5),
                          Text('${recipe.cookTime} Min',
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          const Icon(Icons.restaurant, size: 18),
                          const SizedBox(width: 5),
                          Text('${recipe.servings} Portion',
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border),
                        onPressed: toggleBookmark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Profil dan nama author
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text('Recipe made by: ${recipe.username}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Deskripsi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.secondary.withOpacity(0.45),
                    ),
                    child: Text(recipe.description),
                  ),
                ),
                const SizedBox(height: 20),

                // Ingredients
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                // List Ingredients
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = recipe.ingredients[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(fontSize: 18)), // Bullet point
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${ingredient.quantity} - ', // quantity
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: ingredient.name, // ingredient name
                                    ),
                                  ],
                                ),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Steps
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Steps',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                // List Steps
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.steps.length,
                    itemBuilder: (context, index) {
                      final step = recipe.steps[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Menampilkan nomor langkah dengan penebalan
                            Text(
                              '${step.stepNumber}. ',
                              style: const TextStyle(
                                fontSize:
                                    18, // Ukuran font sama dengan ingredients
                                fontWeight:
                                    FontWeight.bold, // Menebalkan nomor langkah
                              ),
                            ),
                            // Deskripsi langkah
                            Expanded(
                              child: Text(
                                step.description,
                                style: const TextStyle(
                                    fontSize:
                                        18), // Ukuran font sama dengan ingredients
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
