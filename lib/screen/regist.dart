import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mama_recipe/utils/color_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isObscure = true;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        _showErrorDialog('Password tidak sama dengan konfirmasi password.');
        return;
      }

      try {
        // Mendaftar pengguna baru
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Mengirim email verifikasi
        await userCredential.user!.sendEmailVerification();

        // Menyimpan data pengguna ke Firestore
        await _createUser(userCredential.user!);

        _showSuccessDialog();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          _showErrorDialog('Email sudah terdaftar. Gunakan email lain.');
        } else if (e.code == 'invalid-email') {
          _showErrorDialog('Format email tidak valid.');
        } else {
          _showErrorDialog('Terjadi kesalahan: ${e.message}');
        }
      }
    }
  }

  Future<void> _createUser(User user) async {
    try {
      // Mendapatkan reference ke koleksi 'users' di Firestore
      final users = FirebaseFirestore.instance.collection('users');

      // Menambahkan data user
      await users.doc(user.uid).set({
        'username': _usernameController.text.trim(),
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Gagal menyimpan data pengguna: $e');
      _showErrorDialog('Gagal menyimpan data pengguna.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrasi Berhasil'),
          content: const Text(
              'Email verifikasi telah dikirim. Silakan periksa email Anda.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              AppColor.light,
              AppColor.bgLight,
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 80),
            Image.asset(
              'assets/logo.png',
              height: 130,
              width: 130,
            ),
            const SizedBox(height: 15),
            const Text(
              "Cook with Ease, Savor Every Bite!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            "Regist Your Account",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                          ),
                          const SizedBox(height: 25),
                          // Username Field
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.person, color: AppColor.primary),
                                labelText: "Username",
                                labelStyle: TextStyle(color: AppColor.primary),
                                hintText: "person",
                                hintStyle:
                                    TextStyle(color: AppColor.textSecondary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username tidak boleh kosong.';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Email Field
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined,
                                    color: AppColor.primary),
                                labelText: "Email",
                                labelStyle:
                                    const TextStyle(color: AppColor.primary),
                                hintText: "example@gmail.com",
                                hintStyle: const TextStyle(
                                    color: AppColor.textSecondary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email tidak boleh kosong.';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Password Field
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.fingerprint,
                                  color: AppColor.primary,
                                ),
                                labelText: "Password",
                                labelStyle:
                                    const TextStyle(color: AppColor.primary),
                                hintText: "*****",
                                hintStyle: const TextStyle(
                                    color: AppColor.textSecondary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColor.secondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password tidak boleh kosong.';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Confirm Password Field
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.fingerprint,
                                  color: AppColor.primary,
                                ),
                                labelText: "Confirm Password",
                                labelStyle:
                                    const TextStyle(color: AppColor.primary),
                                hintText: "*****",
                                hintStyle: const TextStyle(
                                    color: AppColor.textSecondary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColor.secondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Konfirmasi password tidak boleh kosong.';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Register Button
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _registerUser,
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                primary: AppColor.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Have an account? Login here
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Already have an account? "),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
