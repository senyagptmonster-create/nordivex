import 'package:flutter/material.dart';
import '../app/brand.dart';
import 'screens.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nordivex',
      theme: ThemeData(
        scaffoldBackgroundColor: cBg,
        primaryColor: cAccent,
      ),
      home: const NordivexMain(),
    );
  }
}
