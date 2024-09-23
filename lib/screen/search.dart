import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Search your favorite recipes',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
