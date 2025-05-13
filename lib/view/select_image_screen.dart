import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lottie/lottie.dart';
import 'package:nutriscan_ai/view/nutrition_result_screen.dart';

class SelectImageScreen extends StatefulWidget {
  const SelectImageScreen({Key? key}) : super(key: key);

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, String>> _parsedNutrition = [];

  String _extractedText = '';
  bool _isProcessing = false;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    setState(() {
      _isProcessing = true;
    });

    final inputImage = InputImage.fromFile(File(picked.path));
    final textRecognizer = TextRecognizer();
    final RecognizedText result = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    // Log recognized text for debugging.
    print("Recognized Text: ${result.text}");

    final lowerText = result.text.toLowerCase();

    // Filter by a common header (e.g., "nutrition facts") to improve reliability.
    if (!lowerText.contains("nutrition facts")) {
      setState(() {
        _extractedText = result.text;
        _isProcessing = false;
        _parsedNutrition.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This image does not appear to be a valid nutrition label."),
        ),
      );
      return;
    }

    // Parse recognized text.
    final parsedData = _getParsedNutrition(result.text);

    // Check if we have parsed enough data.
    // You can adjust this threshold as needed.
    if (parsedData.length < 3) {
      setState(() {
        _extractedText = result.text;
        _isProcessing = false;
        _parsedNutrition.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("The image does not seem to contain a complete nutrition label."),
        ),
      );
      return;
    }

    // If we have enough data, update state and navigate.
    setState(() {
      _parsedNutrition.clear();
      _parsedNutrition.addAll(parsedData);
      _extractedText = result.text;
      _isProcessing = false;
    });
  }

  List<Map<String, String>> _getParsedNutrition(String text) {
    final List<Map<String, String>> parsed = [];
    final List<String> lines = text.split('\n');

    // List of known nutrient keywords (FDA style)
    final List<String> nutritionKeywords = [
      'calories',
      'total fat',
      'saturated fat',
      'trans fat',
      'polyunsaturated fat',
      'monounsaturated fat',
      'cholesterol',
      'sodium',
      'total carbohydrate',
      'dietary fiber',
      'soluble fiber',
      'insoluble fiber',
      'sugars',
      'added sugars',
      'total sugars',
      'protein',
      'vitamin a',
      'vitamin c',
      'vitamin d',
      'calcium',
      'iron',
      'potassium',
      'magnesium',
      'zinc',
      'phosphorus',
      'niacin',
      'riboflavin',
      'thiamin',
      'folate',
      'folic acid',
      'vitamin b6',
      'vitamin b12',
      'vitamin e',
      'vitamin k',
      'biotin',
      'pantothenic acid'
    ];

    // Regex to capture a nutrient label, its numerical value, and an optional unit.
    final regex = RegExp(
      r'^\s*([A-Za-z0-9\s\-\(\)%\/]+?)\s*[:\-]?\s*([\d.]+)\s*(mg|g|mcg|kcal|%)?\s*(\(?\d+%?\)?)?',
      caseSensitive: false,
    );

    final Set<String> added = {};

    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      final match = regex.firstMatch(line);
      if (match != null) {
        String label = match.group(1)?.trim().toLowerCase() ?? '';
        String value = '${match.group(2)} ${match.group(3) ?? ''}'.trim();
        if (match.group(4) != null && match.group(4)!.isNotEmpty) {
          value += ' (${match.group(4)})';
        }

        for (final keyword in nutritionKeywords) {
          if (label.contains(keyword) && !added.contains(label)) {
            parsed.add({
              'label': toTitleCase(label),
              'value': value,
            });
            added.add(label);
            break;
          }
        }
      }
    }

    // Attempt to parse ingredients.
    final ingredientsLine = lines.firstWhere(
      (line) => line.toLowerCase().startsWith('ingredients:'),
      orElse: () => '',
    );

    if (ingredientsLine.isNotEmpty) {
      parsed.add({
        'label': 'Ingredients',
        'value': ingredientsLine.split(':').last.trim(),
      });
    }

    return parsed;
  }

  String toTitleCase(String text) {
    return text
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  Widget buildTableSection() {
    if (_isProcessing) {
      return Center(
        child: Lottie.asset('assets/animations/scan.json', height: 200),
      );
    } else if (_parsedNutrition.isNotEmpty) {
      // Navigate only when valid data is present.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NutritionResultScreen(
              nutritionFacts: _parsedNutrition,
            ),
          ),
        );
      });
      return const SizedBox.shrink();
    } else {
      return const Center(
        child: Text(
          "No text scanned yet.",
          style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Scan Nutrition Label"),
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: buildTableSection()),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _customButton("Camera", Icons.camera_alt, Colors.cyanAccent, () {
                    _pickImage(ImageSource.camera);
                  }),
                  _customButton("Gallery", Icons.photo_library, Colors.pinkAccent, () {
                    _pickImage(ImageSource.gallery);
                  }),
                ],
              ),
              const SizedBox(height: 12),
              if (_extractedText.isNotEmpty)
                TextButton.icon(
                  onPressed: () => setState(() {
                    _extractedText = '';
                  }),
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  label: const Text("Clear Text",
                      style: TextStyle(color: Colors.white70)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black),
      label: Text(text, style: const TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.9),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 6,
      ),
    );
  }
}
