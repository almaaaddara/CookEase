import 'package:flutter/material.dart';
import 'package:mama_recipe/screen/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookEase',
      theme: ThemeData(
        fontFamily: ('Roboto'),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => const LoginPage()},
    );
  }
}
