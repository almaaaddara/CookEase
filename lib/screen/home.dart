import 'package:flutter/material.dart';
import 'package:mama_recipe/widgets/categories.dart';
import 'package:mama_recipe/widgets/search_bar.dart';
import 'package:mama_recipe/widgets/last_added.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentCat = "All";

  void _onCategorySelected(String newCategory) {
    setState(() {
      currentCat = newCategory; // Perbarui kategori yang dipilih
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CookEase'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const HomeSearchBar(),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/explore.png"),
                    ),
                  ),
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
                  onCategorySelected: _onCategorySelected, // Pass callback
                ),
                const SizedBox(height: 20),
                const LastAdded(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
