import 'package:flutter/material.dart';
import 'package:mama_recipe/utils/color_theme.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:mama_recipe/services/recipe.dart';
import 'dart:io';

class TitleRecipe extends StatefulWidget {
  final File? image;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController cookTimeController;
  final TextEditingController servingsController;
  final Function(String) onCategoryChanged;
  final Future<void> Function() pickImage;

  const TitleRecipe({
    Key? key,
    this.image,
    required this.titleController,
    required this.descriptionController,
    required this.cookTimeController,
    required this.servingsController,
    required this.onCategoryChanged,
    required this.pickImage,
  }) : super(key: key);

  @override
  State<TitleRecipe> createState() => _TitleRecipeState();
}

class _TitleRecipeState extends State<TitleRecipe> {
  final categories = ["Breakfast", "Lunch", "Dinner"];

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: widget.pickImage,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: AppColor.secondary.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: widget.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        widget.image!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Column(
                      children: [
                        Padding(padding: EdgeInsets.all(18.0)),
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          "Silahkan Pilih Gambar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.titleController,
          decoration: InputDecoration(
            labelText: 'Recipe Title',
            labelStyle: TextStyle(color: AppColor.primary),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.primary)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the recipe title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(color: AppColor.primary),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.primary)),
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the recipe description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Dropdown kategori
        DropdownButtonFormField<String>(
          value: selectedCategory,
          decoration: InputDecoration(
            labelText: 'Category',
            labelStyle: TextStyle(color: AppColor.primary),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.primary)),
          ),
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newCategory) {
            setState(() {
              selectedCategory = newCategory;
            });
            widget.onCategoryChanged(newCategory ?? "Uncategorized");
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a category';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Waktu Memasak',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.primary), // Atur gaya teks sesuai kebutuhan
            ),
            const SizedBox(width: 5),
            Expanded(
              child: TextFormField(
                controller: widget.cookTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '45 min',
                  hintStyle: TextStyle(color: AppColor.primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColor.primary)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cook time';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Porsi',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.primary), // Atur gaya teks sesuai kebutuhan
            ),
            const SizedBox(width: 83),
            Expanded(
              child: TextFormField(
                controller: widget.servingsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '2 Orang',
                  hintStyle: TextStyle(color: AppColor.primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColor.primary)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the servings';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
