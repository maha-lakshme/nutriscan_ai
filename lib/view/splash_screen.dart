import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;


@override
  void initState() {
   
    super.initState();
    Future.delayed(Duration(seconds: 4),() {
      Navigator.pushReplacementNamed(context, 'home');
    },);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027), 
      body: Center(child: Container(
        margin: EdgeInsets.all(24),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
             boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                spreadRadius: 4,
              )
            ],
        ),
        child: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
           Lottie.asset( 'assets/animations/scan.json',height: 180,),
           const SizedBox(height: 20),
              const Text(
                "NutriScan AI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Smart Nutrition Scanner",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              )
          ],
        ),
      ),),
    );
  }
}