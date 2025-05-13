
import 'package:flutter/material.dart';
import 'package:nutriscan_ai/view/home_screen.dart';
import 'package:nutriscan_ai/view/select_image_screen.dart';
import 'package:nutriscan_ai/view/splash_screen.dart';

void main() {
  runApp(const NutriScanApp());
}

class NutriScanApp extends StatelessWidget {
  const NutriScanApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriScan Ai',
      debugShowCheckedModeBanner: false,
      theme:ThemeData.dark(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/':(context) => const SplashScreen(),
        'home': (context) => const HomeScreen(),
         'scanner': (context) => const SelectImageScreen(),
      },
   
    );
  }
}

