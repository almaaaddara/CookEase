import 'package:flutter/material.dart';
import 'package:mama_recipe/utils/color_theme.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk autentikasi Firebase

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final TextEditingController emailController = TextEditingController();

  // Fungsi untuk mereset password
  Future<void> resetPassword(BuildContext context) async {
    String email = emailController.text;

    if (email.isEmpty) {
      // Menampilkan pesan jika email kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
        ),
      );
      return;
    }

    try {
      // Mengirim email reset password melalui Firebase
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Menampilkan pesan berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset link sent to your email'),
        ),
      );
      Navigator.pop(context); // Menutup halaman setelah berhasil
    } on FirebaseAuthException catch (e) {
      // Menangani error jika email tidak ditemukan atau error lainnya
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              colors: [
                AppColor.light, // Warna pertama
                AppColor.bgLight, // Warna kedua
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize
                .max, // Pastikan Column mengisi seluruh tinggi layar
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'assets/logo.png',
                height: 130,
                width: 130,
              ),
              const SizedBox(height: 15),
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 25),
              // Kotak putih
              Center(
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColor.secondary.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Input your email to reset password',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: AppColor.textSecondary),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.primary)),
                          fillColor: AppColor.bgLight.withOpacity(0.6),
                          filled: true,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          resetPassword(
                              context); // Menambahkan pemanggilan fungsi resetPassword
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Send Reset Link',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                  height: 500), // Memberikan ruang ekstra di bagian bawah
            ],
          ),
        ),
      ),
    );
  }
}
