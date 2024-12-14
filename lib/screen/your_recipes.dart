// YourRecipesPage.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mama_recipe/models/food.dart';
import 'package:mama_recipe/screen/detail_recipe.dart';
import 'package:mama_recipe/services/recipe.dart';
import 'package:mama_recipe/utils/color_theme.dart';

class YourRecipesPage extends StatefulWidget {
  const YourRecipesPage({super.key});

  @override
  State<YourRecipesPage> createState() => _YourRecipesPageState();
}

class _YourRecipesPageState extends State<YourRecipesPage> {
  final RecipeService _recipeService = RecipeService();
  User? user;

  @override
  void initState() {
    super.initState();
    user =
        FirebaseAuth.instance.currentUser; // Mendapatkan user yang sedang login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recipes'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: user != null
            ? _recipeService.getUserRecipes(user!.uid)
            : Future.value([]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final daftar = snapshot.data;

          if (daftar != null && daftar.isNotEmpty) {
            return ListView.builder(
              itemCount: daftar.length,
              itemBuilder: (context, index) {
                final recipe = daftar[index];
                return RecipeCard(recipe: recipe);
              },
            );
          } else {
            return const Center(
              child: Text(
                'There is no recipe yet, Please upload a recipe.',
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeCard({required this.recipe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailPage(recipeId: recipe['id']),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      recipe['image'] ?? 'https://via.placeholder.com/100',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['title'] ?? 'Unknown Title',
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
                        //     recipe['profil_user']?['profileImage'] ??
                        //         'https://via.placeholder.com/50',
                        //   ),
                        // ),
                        // const SizedBox(width: 10),
                        Text(
                          recipe['username'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(Icons.restaurant,
                            size: 14, color: Colors.black),
                        Text(
                          " ${recipe['servings'] ?? '-'} Portion",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.timer, size: 14, color: Colors.black),
                        Text(
                          " ${recipe['cookTime'] ?? '-'} Min",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.textSecondary,
                          ),
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
  }
}
