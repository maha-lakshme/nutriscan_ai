import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle; // Correct import for rootBundle
import 'package:nutriscan_ai/view/select_image_screen.dart';
import 'package:nutriscan_ai/view/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---- TEMPORARY DEBUGGING ----
  print("--- Starting .env Load Debug ---");
  try {
    await dotenv.load(fileName: ".env");
    print("dotenv.load() completed.");
    if (dotenv.isInitialized) {
        print("DotEnv IS INITIALIZED.");
        print("GEMINI_API_KEY from dotenv: ${dotenv.env['GEMINI_API_KEY'] ?? 'NOT FOUND IN DOTENV MAP'}");
    } else {
        print("DotEnv IS NOT INITIALIZED after load attempt.");
    }
  } catch (e) {
    print("ERROR during dotenv.load(): $e");
  }

  print("--- Checking .env as a bundled asset via rootBundle ---");
  try {
    // Ensure .env is in pubspec.yaml assets if you expect this to work consistently across all builds/platforms
    String assetContent = await rootBundle.loadString('.env'); 
    print(".env ASSET FOUND via rootBundle! Content starts with: ${assetContent.substring(0, assetContent.length > 20 ? 20 : assetContent.length)}...");
  } catch (assetError) {
    print("ERROR loading .env as an asset via rootBundle: $assetError");
  }
  print("--- End .env Load Debug ---");
  // ---- END TEMPORARY DEBUGGING ----

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
        '/scanner': (context) => const SelectImageScreen(),
      },
   
    );
  }
}

