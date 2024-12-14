import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mama_recipe/screen/forgot_password.dart';
import 'package:mama_recipe/utils/color_theme.dart';
import 'package:mama_recipe/screen/regist.dart';
import 'package:mama_recipe/screen/bottomnavbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi untuk login
  void submit() async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (credential.user != null) {
        // Setelah login berhasil
        if (!credential.user!.emailVerified) {
          // Jika email belum terverifikasi
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Akun Belum Diverifikasi"),
                content: const Text(
                    "Silakan verifikasi email Anda untuk melanjutkan."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Ok"),
                  ),
                ],
              );
            },
          );
        } else {
          // Jika login berhasil dan akun sudah diverifikasi
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavbar(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Menangani kesalahan jika akun tidak ditemukan
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Akun Tidak Ditemukan"),
              content: const Text(
                  "Akun tidak ditemukan, silakan daftar terlebih dahulu."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        );
      } else {
        // Menangani error lainnya
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Login Gagal"),
              content: Text(e.message ?? "Terjadi kesalahan saat login"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body login page
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              AppColor.light, // Warna pertama
              AppColor.bgLight, // Warna kedua
            ],
          ),
        ),
        // Logo
        child: Column(
          children: <Widget>[
            const SizedBox(height: 80),
            Image.asset(
              'assets/logo.png',
              height: 130,
              width: 130,
            ),
            const SizedBox(height: 15),
            const Text("Cook with Ease, Savor Every Bite!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary)),
            const SizedBox(height: 25),
            // Login Container (Kotak Putih)
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
                    child: Column(
                      children: <Widget>[
                        const Text(
                          "Login Your Account",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary),
                        ),
                        const SizedBox(height: 25),
                        // Email
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.person, color: AppColor.primary),
                              labelText: "Email",
                              labelStyle: TextStyle(color: AppColor.primary),
                              hintText: "example@gmail.com",
                              hintStyle:
                                  TextStyle(color: AppColor.textSecondary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Password
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
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
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Tombol Login
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: submit, // Panggil fungsi submit di sini
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Lupa Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Your Password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  color: AppColor.secondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: AppColor.secondary),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}
