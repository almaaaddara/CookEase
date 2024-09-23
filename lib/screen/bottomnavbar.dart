import 'package:flutter/material.dart';
import 'package:mama_recipe/screen/home.dart';
import 'package:mama_recipe/screen/addrecipe.dart';
import 'package:mama_recipe/screen/profile.dart';

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
      body: _widgetOptions[_selectedIndex], // Menampilkan halaman sesuai tab
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex, // Index terpilih
        selectedItemColor: Color(0xFF987D9A),
        unselectedItemColor: Colors.grey[600], // Warna icon terpilih
        onTap: _onItemTapped, // Pindah tab sesuai item yang ditekan
      ),
    );
  }
}
