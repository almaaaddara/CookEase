import 'package:flutter/material.dart';
import 'package:mama_recipe/services/recipe.dart';
import 'package:mama_recipe/screen/detail_recipe.dart';
import 'package:mama_recipe/utils/color_theme.dart';

class ViewAllRecipesPage extends StatelessWidget {
  const ViewAllRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeService = RecipeService(); // Instance dari RecipeService

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Recipes'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: recipeService.getLatestRecipes(
            limit: 20), // Menarik data resep terbaru
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found'));
          }

          final recipes = snapshot.data!; // Data resep yang diterima

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index]; // Setiap data resep
              return GestureDetector(
                onTap: () {
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
                                recipe['image'] ??
                                    'https://via.placeholder.com/150',
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
                                recipe['title'] ?? 'Untitled Recipe',
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
                                  //       recipe['author']['profileImage'] ??
                                  //           'https://via.placeholder.com/50'),
                                  // ),
                                  // const SizedBox(width: 10),
                                  Text(
                                    recipe['username'] ?? 'Unknown Author',
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
