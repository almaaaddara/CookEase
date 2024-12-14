import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama_recipe/models/food.dart';
import 'package:mama_recipe/models/ingredients.dart';
import 'package:mama_recipe/models/step.dart';
import 'package:mama_recipe/services/user.dart';
import 'package:mama_recipe/utils/color_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mama_recipe/widgets/title_recipes_form.dart';
import 'package:mama_recipe/widgets/ingredients_form.dart';
import 'package:mama_recipe/widgets/steps_form.dart';
import 'package:mama_recipe/services/recipe.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final RecipeService _recipeService = RecipeService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cookTimeController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  String? selectedCategory;

  List<Map<String, String>> _ingredients = [];
  List<TextEditingController> _ingredientNameControllers = [];
  List<TextEditingController> _ingredientQuantityControllers = [];

  List<String> _steps = [];
  List<TextEditingController> _stepControllers = [];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> uploadImage(String filePath, String fileName) async {
    try {
      final file = File(filePath);

      // Tentukan referensi ke lokasi penyimpanan
      final storageRef = _storage.ref().child('recipes/$fileName');

      // Unggah file ke Firebase Storage
      final uploadTask = await storageRef.putFile(file);

      // Get URL gambar
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add({"name": "", "quantity": ""});
      _ingredientNameControllers.add(TextEditingController());
      _ingredientQuantityControllers.add(TextEditingController());
      print("Bahan: $_ingredients");
      print("Controller Bahan: $_ingredientNameControllers");
    });
  }

  void _addStep() {
    setState(() {
      _steps.add("");
      _stepControllers.add(TextEditingController());
    });
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    // Loading ...
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uploading recipe...')),
    );

    try {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please upload an image for the recipe.')),
        );
        return;
      }

      // Upload gambar ke Firebase Storage
      String imageUrl =
          await uploadImage(_image!.path, '${_titleController.text}.jpg');

      User? user = FirebaseAuth.instance.currentUser;
      final currentUser = await UserService().getCurrentUser();
      // print("Title: ${_titleController.text}");
      // print("Description: ${_descriptionController.text}");
      // print("CookTime: ${_cookTimeController.text}");
      // print("Servings: ${_servingsController.text}");
      // print("Category: $selectedCategory");
      // print(
      //     "Ingredients: ${_ingredients.map((ingredient) => ingredient['name']).toList()}");
      // print(
      //     "Quantities: ${_ingredients.map((ingredient) => ingredient['quantity']).toList()}");
      // print("Steps: $_steps");

      _steps = _stepControllers.map((controller) => controller.text).toList();
      _ingredients = List.generate(_ingredientNameControllers.length, (index) {
        return {
          'name': _ingredientNameControllers[index].text,
          'quantity': _ingredientQuantityControllers[index].text,
        };
      });
      // Siapkan data model Recipe
      final recipe = Recipe(
        id: '',
        title: _titleController.text,
        description: _descriptionController.text,
        cookTime: int.parse(_cookTimeController.text),
        servings: int.parse(_servingsController.text),
        category: selectedCategory ?? "Uncategorized",
        image: imageUrl,
        userId: user!.uid,
        username: currentUser?['username'],
        // profileUser: currentUser?['profileImage'],
        createdAt: DateTime.now().toIso8601String(),
        ingredients: _ingredients
            .map((ingredient) => Ingredient(
                  name: ingredient['name']!,
                  quantity: ingredient['quantity']!,
                ))
            .toList(),
        steps: _steps
            .asMap()
            .entries
            .map((entry) => foodStep(
                  stepNumber: entry.key + 1,
                  description: entry.value,
                ))
            .toList(),
      );

      // Simpan data resep
      await _recipeService.addRecipe(recipe);

      // Berhasil disimpan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe successfully added!')),
      );

      // Reset form
      _formKey.currentState!.reset();
      _titleController.clear();
      _descriptionController.clear();
      _cookTimeController.clear();
      _servingsController.clear();
      setState(() {
        _image = null;
        _ingredients.clear();
        _ingredientNameControllers.clear();
        _ingredientQuantityControllers.clear();
        _steps.clear();
        _stepControllers.clear();
      });

      print('Recipe data to be added: ${recipe.toJson()}');
    } catch (e) {
      // Gagal disimpan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add recipe: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Recipe'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleRecipe(
                        image: _image,
                        titleController: _titleController,
                        descriptionController: _descriptionController,
                        cookTimeController: _cookTimeController,
                        servingsController: _servingsController,
                        pickImage: _pickImage,
                        onCategoryChanged: (category) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Ingredients(
                        nameControllers: _ingredientNameControllers,
                        quantityControllers: _ingredientQuantityControllers,
                        addIngredient: _addIngredient,
                        onRemoveIngredient: (index) {
                          setState(() {
                            _ingredients.removeAt(index);
                            _ingredientNameControllers.removeAt(index);
                            _ingredientQuantityControllers.removeAt(index);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Steps(
                        stepControllers: _stepControllers,
                        addStep: _addStep,
                        onRemoveStep: (index) {
                          setState(() {
                            _steps.removeAt(index);
                            _stepControllers.removeAt(index);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit Recipe',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
