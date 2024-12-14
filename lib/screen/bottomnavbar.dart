import 'package:flutter/material.dart';
import 'package:mama_recipe/screen/home.dart';
import 'package:mama_recipe/screen/addrecipe.dart';
import 'package:mama_recipe/screen/profile.dart';
import 'package:mama_recipe/utils/color_theme.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  // Daftar widget untuk ditampilkan pada tiap tab
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const AddRecipePage(),
    const ProfilePage(),
  ];

  // Fungsi untuk menangani perubahan tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.home)
                : const Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? const Icon(Icons.add_box)
                : const Icon(Icons.add_box_outlined),
            label: 'Add Recipe',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? const Icon(Icons.person_2)
                : const Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: AppColor.primary,
        selectedItemColor: AppColor.light,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
