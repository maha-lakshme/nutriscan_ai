import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  String _scannedText = "";
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> scanText() async {
    if (_image == null) return;
    final inputImage = InputImage.fromFile(_image!);
    final texRecognizer = TextRecognizer();
    final RecognizedText result = await texRecognizer.processImage(inputImage);
    setState(() {
      _scannedText = result.text;
    });
    texRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('NutriScan OCR'),),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(children: [
        ElevatedButton(onPressed: pickImage, child: Text("Pick a Image")),
           const SizedBox(height: 10),
             if (_image != null)
              Image.file(_image!, height: 200),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: scanText, child: Text("Scan Text")),
             const SizedBox(height: 20),
             Expanded(child: SingleChildScrollView(
              child: Text(_scannedText),
             ))

      ],),
    ),
  );
  }
}
