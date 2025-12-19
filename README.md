# 🐓 Roostify: AI-Powered Rooster Breed Identification
### *A 3rd-Year BSIT Academic Project*

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![TensorFlow Lite](https://img.shields.io/badge/TFLite-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)](https://www.tensorflow.org/lite)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)

---

## 🎓 Academic Overview
This project was developed as a major milestone for my **Bachelor of Science in Information Technology (BSIT)** curriculum. It serves as a practical application of mobile development, machine learning integration, and cloud-based data management studied during my 3rd year.

**Roostify** is a state-of-the-art mobile application designed to help poultry enthusiasts, breeders, and farmers identify rooster breeds instantly using Computer Vision. Built with Flutter, it combines a sleek, modern UI with powerful on-device Machine Learning.


---

## ✨ Key Features

### 🔍 Instant Identification
*   **Dual-Input System:** Use your camera for real-time capture or upload high-quality images from your phone gallery.
*   **On-Device AI:** Powered by a customized TensorFlow Lite model, the app analyzes images locally for maximum speed and privacy.
*   **Confidence Logic:** Only provides a result if the model is >60% certain, ensuring high reliability.

### 📊 Advanced Analytics
*   **Live Probability Graph:** Visualize the mathematical "thought process" of the AI. See how much it considered other breeds before reaching a conclusion.
*   **Top 5 Breakdown:** View a ranked list of the most likely matches, complete with interactive tooltips.
*   **Global Logging:** Every identified breed is securely synced to Firebase Firestore to build real-time analytics.

### 📖 Breed Encyclopedia
*   **Detailed Catalog:** Explore built-in information for every supported breed.
*   **Rich Content:** Learn about historical origins, physical characteristics, and unique plumage patterns.

---

## 🧬 Supported Breeds

Roostify currently supports ultra-accurate detection for the following breeds:
*   **Appenzeller** • **Ayam Cemani** • **Dominique** • **Frizzle**
*   **Onagadori** • **Phoenix** • **Polish** • **Sebright**
*   **Serama** • **Turken**

---

## 🛠️ Technology Stack

*   **Frontend:** [Flutter](https://flutter.dev) (Dart) for high-performance cross-platform rendering.
*   **Inference Engine:** [TFLite Flutter](https://pub.dev/packages/tflite_flutter) for running neural networks on mobile hardware.
*   **Database:** [Cloud Firestore](https://firebase.google.com/products/firestore) for secure, real-time data persistence.
*   **UI/UX:** Built with a custom design system featuring:
    *   Glassmorphic overlays
    *   Smooth micro-animations
    *   Interactive charts (via `fl_chart`)

---

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK (v3.0.0+)
*   Android Studio / VS Code
*   A physical device or emulator with camera support

### Installation
1.  **Clone the Repository**
    ```bash
    git clone https://github.com/yourusername/roostify.git
    ```
2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```
3.  **Run the App**
    ```bash
    flutter run
    ```

---

## 🤝 Contributing
Contributions are welcome! If you have ideas for new breeds or UI improvements, feel free to open an issue or submit a pull request.

---

## �‍💻 About the Author
I am a **3rd-Year BSIT Student** passionate about bridging the gap between agriculture and technology. This project is a testament to my journey in mastering:
*   **Cross-Platform Development** with Flutter & Dart.
*   **Machine Learning Deployment** specifically focusing on on-device optimization.
*   **Cloud Infrastructure** through the Firebase ecosystem.

---

<p align="center">
  <b>Final Project: 3rd Year BSIT Milestone</b><br>
  Made with ❤️ for the Poultry Community
</p>

