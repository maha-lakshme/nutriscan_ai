import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NutritionAiAnalyzer {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_API_KEY_WAS_NOT_FOUND';
  static const String _geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent'; 

  Future<String?> getAiHealthAdvice({

    required String ocrText,
    required String targetLanguage, // e.g., "English", "Spanish", "French"
  }) async {
    if (_apiKey == 'YOUR_API_KEY_WAS_NOT_FOUND') {
      print("Error: Gemini API Key not found in .env file. Please ensure it is set correctly.");
      return "Error: API Key not configured. Check .env file.";
    }

    // 1. Construct the Prompt - Now asks AI to parse AND advise
    String prompt = """
You are an intelligent nutrition label analyzer and health advisor.
From the following OCR text extracted from a food product, please perform these tasks:

1.  Identify and list the key nutrition facts (e.g., Calories, Total Fat, Saturated Fat, Trans Fat, Cholesterol, Sodium, Total Carbohydrate, Dietary Fiber, Total Sugars, Added Sugars, Protein, vitamins, minerals). 
    Present these facts clearly if found. If specific facts are not clearly discernible, state that.
2.  Identify and list the ingredients if they are present in the text.
3.  Based on YOUR PARSED understanding of the nutrition facts and ingredients, provide health-focused advice targeted for a general audience. This advice should be easy to understand.
4.  The health advice should:
    a.  Briefly highlight any significant nutritional concerns (e.g., high in sugar, sodium, unhealthy fats).
    b.  Briefly highlight any potential nutritional benefits (e.g., good source of fiber, protein, vitamins).
    c.  Offer 1-2 general, actionable wellness tips related to consuming a product with such a nutritional profile.

IMPORTANT: Provide the entire response (parsed facts, ingredients, and health advice) ONLY in the following language: $targetLanguage.
If the OCR text itself appears to be in a different language, still perform your analysis and deliver your complete response ONLY in $targetLanguage.

OCR Text from Nutrition Label:
--- START OCR TEXT ---
$ocrText
--- END OCR TEXT ---

Your comprehensive analysis and advice in $targetLanguage:
""";

    // 2. Prepare the Request Body for Gemini API
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.5, // Slightly lower for more structured output initially
        "topK": 1,
        "topP": 0.95,
        "maxOutputTokens": 1024, // Increased for potentially longer response (facts + advice)
      }
    });

    // 3. Make the API Call
    try {
      final response = await http.post(
        Uri.parse('$_geminiApiUrl?key=$_apiKey'), 
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        
        if (decodedResponse['candidates'] != null &&
            decodedResponse['candidates'].isNotEmpty &&
            decodedResponse['candidates'][0]['content'] != null &&
            decodedResponse['candidates'][0]['content']['parts'] != null &&
            decodedResponse['candidates'][0]['content']['parts'].isNotEmpty &&
            decodedResponse['candidates'][0]['content']['parts'][0]['text'] != null) {
          return decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        } else if (decodedResponse['promptFeedback'] != null && 
                   decodedResponse['promptFeedback']['blockReason'] != null) {
          String reason = decodedResponse['promptFeedback']['blockReason'];
          String safetyRatings = (decodedResponse['promptFeedback']['safetyRatings'] as List)
                                  .map((r) => "${r['category']}: ${r['probability']}")
                                  .join(", ");
          print('Error: Prompt blocked by Gemini API. Reason: $reason. Ratings: $safetyRatings');
          return 'Error: AI could not process the request due to content policy. Reason: $reason.';
        }
        else {
           print('Error: Unexpected Gemini API response format.');
           print('Response Status Code: ${response.statusCode}');
           print('Response Body: ${response.body}');
           return 'Error: Could not parse AI response. Please check logs.';
        }
      } else {
        print('Error calling Gemini API: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return 'Error: AI service unavailable (Code: ${response.statusCode}). Check logs.';
      }
    } catch (e) {
      print('Exception calling Gemini API: $e');
      return 'Error: Could not connect to AI service. Check network and API endpoint.';
    }
  }
} 