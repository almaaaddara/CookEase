import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mama_recipe/utils/color_theme.dart';
import 'package:mama_recipe/services/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? currentUsername;
  String? currentEmail;
  File? _image;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  // Fungsi untuk memuat data pengguna saat ini
  Future<void> _loadCurrentUser() async {
    final userData = await _userService.getCurrentUser();
    if (userData != null) {
      setState(() {
        currentUsername = userData['username'];
        currentEmail = userData['email'];
        _usernameController.text = currentUsername ?? '';
        _emailController.text = currentEmail ?? '';

        if (userData['profileImageUrl'] != null) {
          _image = File(userData['profileImageUrl']);
        }
      });
    }
  }

  // Fungsi untuk mengambil gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk mengunggah gambar ke Firebase Storage
  Future<String?> _uploadImage(File image) async {
    try {
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString(); // Nama file unik
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref
          .getDownloadURL(); // Mendapatkan URL setelah upload
      return downloadUrl;
    } catch (e) {
      print("Error saat mengunggah gambar: $e");
      return null;
    }
  }

  Future<void> _updateProfile() async {
    String userId =
        (await _userService.getCurrentUser())?['id'] ?? ''; // Ambil ID pengguna
    Map<String, dynamic> updatedData = {
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
    };

    if (_image != null) {
      String? uploadedImageUrl = await _uploadImage(_image!);
      if (uploadedImageUrl != null) {
        updatedData['profileImageUrl'] =
            uploadedImageUrl; // Tambahkan URL gambar ke data
      }
    }

    await _userService.updateUser(userId, updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColor.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _image != null
                            ? FileImage(
                                _image!) // Menampilkan gambar yang dipilih
                            : const AssetImage(
                                    'assets/profile.jpg') // Gambar default
                                as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColor.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.white),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUsername ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentEmail ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'New Username',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter new username'),
              ),
              const SizedBox(height: 20),
              const Text(
                'New Email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController, // Menampilkan email saat ini
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter new email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Memperbarui profil...')),
                    );

                    try {
                      await _updateProfile(); // Panggil fungsi untuk memperbarui profil
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Profil berhasil diperbarui')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Terjadi kesalahan: $e')),
                      );
                    }

                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(
                          context); // Kembali ke halaman sebelumnya setelah beberapa detik
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
