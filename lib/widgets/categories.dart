import 'package:flutter/material.dart';
import 'package:mama_recipe/models/category.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.currentCat,
    required this.onCategorySelected, // Tambahkan parameter callback
  });

  final String currentCat;
  final ValueChanged<String>
      onCategorySelected; // Callback untuk kategori yang dipilih

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categories.length,
          (index) => GestureDetector(
            onTap: () {
              onCategorySelected(
                  categories[index]); // Panggil callback saat kategori dipilih
            },
            child: Container(
              decoration: BoxDecoration(
                color: currentCat == categories[index]
                    ? Color(0xFF987D9A) // Warna dari palet Anda (dipilih)
                    : Colors.transparent, // Warna default (tidak dipilih)
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: currentCat == categories[index]
                      ? Color(0xFF987D9A) // Warna border kategori yang dipilih
                      : Color(
                          0xFFBB9AB1), // Warna border kategori yang tidak dipilih
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.only(right: 20),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: currentCat == categories[index]
                      ? Color(0xFFFEFBD8) // Warna teks kategori yang dipilih
                      : Color(
                          0xFF987D9A), // Warna teks kategori yang tidak dipilih
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
