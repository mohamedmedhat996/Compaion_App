import 'package:companion/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:companion/screens/bottom_Nav.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      primaryColor: Color.fromRGBO(10, 10, 10, 1.0)
      ),
      home: LoginPage(),
    );
  }
}