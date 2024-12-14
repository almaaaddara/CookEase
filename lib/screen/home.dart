import 'package:flutter/material.dart';
import 'package:mama_recipe/screen/all_recipe.dart';
import 'package:mama_recipe/screen/detail_recipe.dart';
import 'package:mama_recipe/screen/history.dart';
import 'package:mama_recipe/services/recipe.dart';
import 'package:mama_recipe/widgets/categories.dart';
import 'package:mama_recipe/widgets/search_bar.dart';
import 'package:mama_recipe/widgets/last_added.dart';
import 'package:mama_recipe/screen/food_category.dart';
import 'package:mama_recipe/models/food.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentCat = "All";
  List<Recipe> allRecipes = [];
  List<Recipe> filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  // Simulasi pengambilan data resep dari API atau database
  void _loadRecipes() async {
    try {
      // Retrieve all recipes from the service
      final allRecipesData = await RecipeService().getAllRecipes();

      setState(() {
        allRecipes = allRecipesData;
        filteredRecipes = allRecipesData;
      });
    } catch (e) {
      print("Error loading recipes: $e");
    }
  }

  // Fungsi untuk menangani pencarian
  void _handleSearch(String query) {
    final results = allRecipes.where((recipe) {
      final title = recipe.title.toLowerCase();
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery); // Filter berdasarkan judul
    }).toList();

    setState(() {
      filteredRecipes = results;
    });

    if (results.isEmpty) {
      print("Tidak ada resep yang ditemukan untuk query: $query");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CookEase'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Arahkan ke halaman riwayat resep
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  HomeSearchBar(
                    onSearch: _handleSearch, // Mengirim query ke _handleSearch
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Categories(
                    currentCat: currentCat,
                    onCategorySelected: (category) {
                      setState(() {
                        currentCat = category;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FoodCategoryPage(category: category),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const LastAdded(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
