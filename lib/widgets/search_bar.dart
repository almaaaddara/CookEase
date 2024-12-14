import 'package:flutter/material.dart';
import 'package:mama_recipe/utils/color_theme.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key, required this.onSearch});

  final Function(String) onSearch;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.bgLight,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction
                  .search, // Gunakan tombol Enter untuk pencarian
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search any recipes",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              onChanged: (query) {
                widget.onSearch(query);
              },
              onSubmitted: (query) {
                widget.onSearch(
                    query); // Panggil pencarian saat tombol Enter ditekan
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                });
                widget.onSearch(''); // Bersihkan hasil pencarian
              },
            ),
        ],
      ),
    );
  }
}
