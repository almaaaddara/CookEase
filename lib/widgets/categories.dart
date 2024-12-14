import 'package:flutter/material.dart';
import 'package:mama_recipe/models/category.dart';
import 'package:mama_recipe/screen/food_category.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.currentCat,
    required this.onCategorySelected,
  });

  final String currentCat;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, // Untuk membatasi grid view di dalam scroll
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Jumlah kolom dalam grid
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2, // Rasio lebar/tinggi tiap item grid
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            // Navigasi ke halaman FoodCategoryPage dengan kategori yang dipilih
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FoodCategoryPage(category: category["name"]!),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(category["image"]!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), // Berlaku untuk semua kategori
                  BlendMode.darken,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              category["name"]!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
