import 'package:flutter/material.dart';
import 'package:mama_recipe/screen/bookmarks.dart';
import 'package:mama_recipe/screen/edit_profile.dart';
import 'package:mama_recipe/screen/login.dart';
import 'package:mama_recipe/screen/your_recipes.dart';
import 'package:mama_recipe/utils/color_theme.dart';
import 'package:mama_recipe/services/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: UserService().getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Menampilkan loader saat data sedang diambil
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data pengguna tidak ditemukan.'));
          }

          final userData = snapshot.data!;

          return Container(
            // padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                // Profil
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColor.secondary,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 55,
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: userData['profileImage'] != null
                              ? NetworkImage(userData['profileImage'])
                              : AssetImage('assets/profile.jpg')
                                  as ImageProvider,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userData['username'] ?? 'Username',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userData['email'] ?? 'example@mail.com',
                          style: const TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Edit Profile
                        // ElevatedButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const EditProfilePage(),
                        //       ),
                        //     );
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor:
                        //         AppColor.primary, // Warna tombol primary
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 20, vertical: 10),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   child: const Text(
                        //     'Edit Profile',
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Bookmarks
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookmarksPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.bookmark,
                            color: AppColor.secondary,
                          ),
                          Text(
                            'Your Bookmarks',
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Recipes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const YourRecipesPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.menu_book_rounded,
                              color: AppColor.secondary),
                          Text(
                            'Your Recipes',
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Logout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false, // Menghapus semua rute sebelumnya
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                          Icon(Icons.exit_to_app, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
