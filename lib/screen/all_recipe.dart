import 'package:flutter/material.dart';
import 'package:mama_recipe/services/recipe.dart'; // Ensure RecipeService is imported
import 'package:mama_recipe/screen/detail_recipe.dart'; // Recipe detail page
import 'package:mama_recipe/utils/color_theme.dart'; // Assuming you have a color theme
import 'package:mama_recipe/models/food.dart'; // Ensure you import your Recipe model

class AllRecipesPage extends StatelessWidget {
  const AllRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Using FutureBuilder to load all recipes
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Recipes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: RecipeService().getAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Show error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found.')); // No recipes
          }

          final recipes = snapshot.data!;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to recipe detail page when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecipeDetailPage(recipeId: recipe.id!),
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
                        // Recipe image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(recipe.image ??
                                  'default_image_url'), // Fallback image if none exists
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Recipe details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  Text(
                                    recipe.username,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColor
                                            .textSecondary), // Assuming you have color theme
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  const Icon(Icons.restaurant,
                                      size: 14, color: Colors.black),
                                  Text(
                                    " ${recipe.servings} Portion",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColor.textSecondary),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.timer,
                                      size: 14, color: Colors.black),
                                  Text(
                                    " ${recipe.cookTime} Min",
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
