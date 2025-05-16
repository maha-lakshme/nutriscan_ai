import 'package:flutter/material.dart';

class NutritionResultScreen extends StatefulWidget {
  final String aiHealthAdvice;

  const NutritionResultScreen({
    Key? key,
    required this.aiHealthAdvice,
  }) : super(key: key);

  @override
  State<NutritionResultScreen> createState() => _NutritionResultScreenState();
}

class _NutritionResultScreenState extends State<NutritionResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Darker, more sophisticated background
      appBar: AppBar(
        title: const Text(
          "AI Health Insights",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent, // Fully transparent AppBar
        elevation: 0,
        centerTitle: true, // Center title for better balance
        iconTheme: const IconThemeData(color: Colors.white), // Ensure back button is visible
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Increased padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AI Generated Advice:",
                          style: TextStyle(
                            color: Colors.cyanAccent[100], // Brighter accent for title
                            fontSize: 20, // Slightly larger title
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12), // Increased spacing
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16), // Increased padding
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3), // Darker, semi-transparent card
                            borderRadius: BorderRadius.circular(12), // More rounded corners
                            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)) // Subtle border accent
                          ),
                          child: Text(
                            widget.aiHealthAdvice,
                            style: const TextStyle(
                              color: Colors.white, // Brighter text for contrast
                              fontSize: 16,
                              height: 1.6, // Increased line height
                            ),
                          ),
                        ),
                        const SizedBox(height: 28), // Increased spacing
                        Text(
                          "Disclaimer:",
                          style: TextStyle(
                            color: Colors.pinkAccent[100], // Different accent for disclaimer title
                            fontSize: 18, // Slightly larger
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12), // Increased spacing
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16), // Increased padding
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2), // Darker, semi-transparent card
                            borderRadius: BorderRadius.circular(12), // More rounded corners
                             border: Border.all(color: Colors.pinkAccent.withOpacity(0.2)) // Subtle border accent
                          ),
                          child: Text(
                            "This advice is AI-generated and for informational purposes only. It is not a substitute for professional medical or nutritional consultation. Always consult with a qualified healthcare provider for any health concerns or before making any decisions related to your health or treatment.",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7), // Slightly brighter for readability
                              fontSize: 13, // Slightly larger
                              fontStyle: FontStyle.italic,
                              height: 1.5, // Increased line height
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24), // Increased spacing
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.camera_alt_outlined, color: Colors.black), // Outlined icon
                  label: const Text(
                    "Scan Another Label",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Slightly larger button text
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    shape: RoundedRectangleBorder( // More modern button shape
                       borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16), // Larger button
                    elevation: 8, // Increased elevation for more pop
                    shadowColor: Colors.cyanAccent.withOpacity(0.5), // Softer shadow
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
