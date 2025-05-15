import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:nutriscan_ai/services/nutrition_ai_analyzer.dart';
import 'nutrition_result_screen.dart';

class SelectImageScreen extends StatefulWidget {
  const SelectImageScreen({Key? key}) : super(key: key);

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;
  String _ocrText = '';
  
  // AI Analyzer and Language Selection
  final NutritionAiAnalyzer _aiAnalyzer = NutritionAiAnalyzer();
  String _selectedLanguage = 'English'; // Default language
  final List<String> _supportedLanguages = [
    'English', 'Spanish', 'French', 'German', 'Hindi', 'Arabic', 'Chinese (Simplified)', 'Japanese', 'Korean', 'Portuguese', 'Russian'
  ]; 
  String? _aiAdvice; // To store AI advice

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file == null) return;

    setState(() {
      _isProcessing = true;
      _ocrText = ''; 
      _aiAdvice = null; // Clear previous advice
    });

    final inputImage = InputImage.fromFile(File(file.path));
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    _ocrText = recognizedText.text;
    print("Full OCR Text:\n$_ocrText");

    String lowerOcrText = _ocrText.toLowerCase();
    
    print("--- Label Check Debug (Strategy 1.1) ---");

    bool hasNutritionKeyword = lowerOcrText.contains("nutrition") || lowerOcrText.contains("nutritional");
    
    int coreNutrientMentions = 0;
    const List<String> coreNutrients = ["energy", "calories", "protein", "fat", "carbohydrate", "fibre", "fiber", "sodium", "sugars"];
    for (String nutrient in coreNutrients) {
      if (lowerOcrText.contains(nutrient)) {
        coreNutrientMentions++;
      }
    }
    
    bool hasValueLikePatterns = RegExp(r'\d\s*(g|mg|mcg|µg|kcal|kj|%|iu)').hasMatch(lowerOcrText);

    print("Contains 'nutrition'/'nutritional': $hasNutritionKeyword");
    print("Core nutrient mentions (found $coreNutrientMentions)");
    print("Has value-like patterns: $hasValueLikePatterns");

    // Revised logic: 
    // Primary pass: has nutrition keyword, at least 2 core nutrients, and value patterns.
    // Secondary pass (if keyword missing): at least 4 core nutrients and value patterns.
    bool primaryPass = hasNutritionKeyword && coreNutrientMentions >= 2 && hasValueLikePatterns;
    bool secondaryPass = !hasNutritionKeyword && coreNutrientMentions >= 4 && hasValueLikePatterns;

    bool isPotentiallyNutritionLabel = _ocrText.isNotEmpty && (primaryPass || secondaryPass);
    
    print("Primary Pass (keyword + >=2 nutrients + values): $primaryPass");
    print("Secondary Pass (no keyword + >=4 nutrients + values): $secondaryPass");
    print("isPotentiallyNutritionLabel evaluated as: $isPotentiallyNutritionLabel");

    if (isPotentiallyNutritionLabel) {
      _aiAdvice = await _aiAnalyzer.getAiHealthAdvice(
        ocrText: _ocrText, 
        targetLanguage: _selectedLanguage,
      );

      setState(() {
        _isProcessing = false; 
      });

      if (_aiAdvice != null && _aiAdvice!.isNotEmpty && !_aiAdvice!.startsWith("Error:")) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NutritionResultScreen(
              aiHealthAdvice: _aiAdvice!,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_aiAdvice ?? "Failed to get AI health advice. Please try again.")),
        );
      }
    } else {
      setState(() {
        _isProcessing = false; 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image does not appear to contain typical nutrition information or values. Please try a clearer image or ensure the label is well lit."),
        ),
      );
    }
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

  Widget _buildLanguageSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20), // Added margin for better spacing
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30), // More rounded corners
        border: Border.all(color: Colors.white.withOpacity(0.2)) // Subtle border
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          isExpanded: true,
          dropdownColor: Colors.grey[850], // Darker dropdown
          icon: const Icon(Icons.translate_rounded, color: Colors.cyanAccent), // Changed icon and color
          style: const TextStyle(color: Colors.white, fontSize: 16),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLanguage = newValue;
              });
            }
          },
          items: _supportedLanguages.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(child: Text(value, style: TextStyle(color: _selectedLanguage == value ? Colors.cyanAccent : Colors.white))) // Highlight selected
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("NutriScan AI", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3, // Give more space to OCR text view
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1))
                  ),
                  child: _isProcessing
                      ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent)))
                      : Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _ocrText.isNotEmpty ? _ocrText : "Scan a nutrition label to get AI health advice.",
                                style: TextStyle(
                                  color: _ocrText.isNotEmpty ? Colors.white70 : Colors.white38, 
                                  fontSize: _ocrText.isNotEmpty ? 14 : 16,
                                  fontStyle: _ocrText.isNotEmpty ? FontStyle.normal : FontStyle.italic
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              // const SizedBox(height: 10), // Adjusted spacing
              _buildLanguageSelector(),
              const SizedBox(height: 20), // Adjusted spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _customButton("Camera", Icons.camera_alt_rounded, Colors.cyanAccent, () {
                      _pickImage(ImageSource.camera);
                    }),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _customButton("Gallery", Icons.photo_library_rounded, Colors.pinkAccent, () {
                      _pickImage(ImageSource.gallery);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 15), // Adjusted spacing
            ],
          ),
        ),
      ),
    );
  }
}
