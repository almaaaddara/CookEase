import 'package:flutter/material.dart';
import 'package:mama_recipe/services/recipe.dart'; // Pastikan impor RecipeService
import 'package:mama_recipe/screen/detail_recipe.dart'; // Halaman detail resep
import 'package:mama_recipe/utils/color_theme.dart';

class FoodCategoryPage extends StatelessWidget {
  final String category;

  const FoodCategoryPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // Gunakan FutureBuilder untuk memuat resep berdasarkan kategori
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Food'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: RecipeService()
            .getRecipesCategory(category), // Panggil getRecipesCategory
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }

          final recipes = snapshot.data!;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  // detail resep
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecipeDetailPage(recipeId: recipe['id']),
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
                                  recipe['image'] ?? 'default_image_url'),
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
                                  //       recipe['author']['profileImage']),
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
