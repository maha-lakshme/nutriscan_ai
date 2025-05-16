# NutriScan AI  quétง่าย ได้สุขภาพ 🥗📸

[![Platform Flutter](https://img.shields.io/badge/Platform-Flutter-blue.svg)](https://flutter.dev)
[![Language Dart](https://img.shields.io/badge/Language-Dart-orange.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

NutriScan AI is a Flutter-based mobile application designed to help users understand the nutritional content of food products quickly and easily. By simply taking a photo of a nutrition label or selecting an image from their gallery, users can get AI-powered health advice and insights in their preferred language.

## ✨ Features

*   **📷 Image-to-Text (OCR):** Scan nutrition labels using your device's camera or pick an image from the gallery.
*   **🔍 Smart Label Detection:** Intelligently identifies if the scanned image contains relevant nutritional information.
*   **🤖 AI-Powered Health Advice:** Get personalized health advice and analysis based on the extracted nutritional data.
*   **🌐 Multi-Language Support:** Receive AI advice in various languages including English, Spanish, French, German, Hindi, Arabic, Chinese (Simplified), Japanese, Korean, Portuguese, and Russian.
*   **📱 User-Friendly Interface:** Clean, intuitive, and responsive design for a seamless user experience.
*   **📊 Results Display:** Clearly presents the AI-generated health advice.

## 🚀 Technologies Used

*   **Flutter:** For cross-platform mobile application development.
*   **Dart:** Programming language for Flutter.
*   **Image Picker (`image_picker`):** To select images from the gallery or capture photos using the camera.
*   **Google ML Kit Text Recognition (`google_mlkit_text_recognition`):** For extracting text from images (OCR).
*   **Nutrition AI Analyzer Service:** (Assumed) A backend service or model that processes OCR text and provides health advice.

## 🛠️ Setup & Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/YOUR_USERNAME/nutriscan_ai.git
    cd nutriscan_ai
    ```
2.  **Ensure you have Flutter SDK installed.** If not, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Set up Firebase (for Google ML Kit):**
    *   Follow the instructions to add Firebase to your Flutter app: [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup)
    *   Ensure you have the necessary configuration files (e.g., `google-services.json` for Android and `GoogleService-Info.plist` for iOS) in your project.
    *   For ML Kit on Android, ensure the following dependency is added to your `android/app/build.gradle` if not already present by the plugin:
        ```gradle
        dependencies {
            // ... other dependencies
            implementation 'com.google.android.gms:play-services-mlkit-text-recognition:18.0.0' // Or the latest version
        }
        ```
    *   For ML Kit on iOS, you might need to update your `Podfile`.
5.  **Run the app:**
    ```bash
    flutter run
    ```

    *Note: Ensure you have a connected device or a running emulator/simulator.*

## 📖 How to Use

1.  Launch the NutriScan AI app.
2.  Select your preferred language for receiving health advice from the dropdown menu.
3.  Tap the **"Camera"** button to take a new photo of a nutrition label or tap the **"Gallery"** button to choose an existing image.
4.  The app will process the image and extract the text.
5.  If a nutrition label is detected, the app will send the text to the AI analyzer.
6.  View the AI-generated health advice on the results screen.
7.  If the image doesn't seem to contain nutrition information, a message will prompt you to try again.

## 🖼️ Screenshots

*(Consider adding screenshots of your app here to showcase its features and UI. For example: Main Screen, Image Scanning, Results Screen)*

```
[Image of Main Screen]
[Image of Camera/Gallery Selection]
[Image of OCR in progress/text display]
[Image of Nutrition Result Screen]
```

## 🔮 Future Improvements

*   Barcode scanning for quick product identification.
*   History of scanned items.
*   User accounts for personalized tracking and advice.
*   Detailed breakdown of nutrients beyond AI advice.
*   Integration with health and fitness apps.

## 🤝 Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/your-feature-name`).
3.  Make your changes.
4.  Commit your changes (`git commit -m 'Add some feature'`).
5.  Push to the branch (`git push origin feature/your-feature-name`).
6.  Open a Pull Request.

Please make sure to update tests as appropriate.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details (though you'll need to create this file if you want a specific license). If no `LICENSE.md` is present, it defaults to standard copyright.

---

_Replace `YOUR_USERNAME` in the clone URL with your actual GitHub username._
_Consider creating a `LICENSE.md` file (e.g., with the MIT License text) if you want to explicitly define the license._
