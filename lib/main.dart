import 'package:flutter/material.dart';
import 'package:academic_management/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academic Management Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.white,
          background: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
      ),
      home: LoginPage(),
    );
  }
}
