import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body login page
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
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
              'assets/logo.png', // Path gambar logo
              height: 130, // Tinggi logo
              width: 130, // Lebar logo
            ),
            const SizedBox(height: 15),
            Text("Cook with Ease, Savor Every Bite!",
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: AppColor.primary)),
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
                // Text Field Login Form
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text("Login Your Account",
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(color: AppColor.primary)),
                        const SizedBox(height: 25),
                        // Email
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
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
                              // fillColor: AppColor.bgLight,
                              // filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Password
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            obscureText:
                                _isObscure, // Mengatur status visibilitas
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.fingerprint,
                                color: AppColor.primary,
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(color: AppColor.primary),
                              hintText: "*****",
                              hintStyle:
                                  TextStyle(color: AppColor.textSecondary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // Ikon untuk mengubah visibilitas password
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColor.secondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure =
                                        !_isObscure; // Toggle visibility
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Tombol Login
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomNavbar(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                shape: RoundedRectangleBorder()),
                            child: Text(
                              "Login",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Teks "Don't have an account?" dan "Register"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account? ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: AppColor.secondary),
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
