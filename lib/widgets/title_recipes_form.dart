import 'package:flutter/material.dart';
import 'dart:io';

class TitleRecipe extends StatelessWidget {
  final File? image;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController prepTimeController;
  final TextEditingController cookTimeController;
  final TextEditingController servingsController;
  final VoidCallback pickImage;

  const TitleRecipe({
    Key? key,
    this.image,
    required this.titleController,
    required this.descriptionController,
    required this.prepTimeController,
    required this.cookTimeController,
    required this.servingsController,
    required this.pickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: pickImage,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        image!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                      size: 50,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Recipe Title',
            border: OutlineInputBorder(),
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
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the recipe description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: prepTimeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Preparation Time (minutes)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the preparation time';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: cookTimeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Cook Time (minutes)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the cook time';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: servingsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Servings',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the number of servings';
            }
            return null;
          },
        ),
      ],
    );
  }
}
