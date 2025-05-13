import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void startScan(BuildContext context) {
    Navigator.pushNamed(context, 'scanner');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: GlassmorphicContainer(
                      width: screenWidth * 0.9,
                      height: constraints.maxHeight * 0.4,
                      borderRadius: 30,
                      blur: 20,
                      alignment: Alignment.center,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: 1.5,
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      // Wrap the child with Center and Padding to help with alignment and avoid clipping.
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0), // Adjust as needed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Scan a Nutrition Label",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.05),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7A2A88),
                                  shape: const StadiumBorder(),
                                  elevation: 6,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.08,
                                    vertical: constraints.maxHeight * 0.02,
                                  ),
                                ),
                                onPressed: () => startScan(context),
                                child: Text(
                                  "Start Scanning",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
