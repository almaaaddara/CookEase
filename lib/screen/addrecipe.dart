import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mama_recipe/widgets/title_recipes_form.dart';
import 'package:mama_recipe/widgets/ingredients_form.dart';
import 'package:mama_recipe/widgets/steps_form.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prepTimeController = TextEditingController();
  final TextEditingController _cookTimeController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();

  List<Map<String, String>> _ingredients = [];
  List<String> _steps = [];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add({"name": "", "quantity": ""});
    });
  }

  void _addStep() {
    setState(() {
      _steps.add("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Recipe'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleRecipe(
                  image: _image,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  prepTimeController: _prepTimeController,
                  cookTimeController: _cookTimeController,
                  servingsController: _servingsController,
                  pickImage: _pickImage,
                ),
                const SizedBox(height: 16),
                Ingredients(
                  ingredients: _ingredients,
                  addIngredient: _addIngredient,
                  onNameChanged: (index, value) {
                    setState(() {
                      _ingredients[index]['name'] = value;
                    });
                  },
                  onQuantityChanged: (index, value) {
                    setState(() {
                      _ingredients[index]['quantity'] = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Steps(
                  steps: _steps,
                  addStep: _addStep,
                  onStepChanged: (index, value) {
                    setState(() {
                      _steps[index] = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recipe added!')),
                        );
                      }
                    },
                    child: const Text('Submit Recipe'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
