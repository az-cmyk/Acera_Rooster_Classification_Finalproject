import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loading_screen.dart';
import 'home_screen.dart';
import 'breeds_screen.dart';
import 'classification_screen.dart';
import 'result_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    // Continue executing app even if Firebase fails
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const RoostifyApp());
}

class RoostifyApp extends StatelessWidget {
  const RoostifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roostify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'System',
        useMaterial3: true,
      ),
      home: const LoadingScreen(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
  }

  void _handleImageSelected(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  void _handleClassificationResult(Map<String, dynamic> result) {
    if (_selectedImage != null && result.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            breedName: result['class'] ?? 'Unknown',
            confidence: result['confidence'] ?? 0.0,
            imagePath: _selectedImage!,
            allScores: result['scores'] as List<dynamic>,
            allLabels: result['labels'] as List<String>,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: HomeScreen(
          onClassifyTap: _navigateToClassification,
          onBreedsTap: _navigateToBreeds,
        ),
      ),
    );
  }

  void _navigateToClassification() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassificationScreen(
          onImageSelected: _handleImageSelected,
          onClassificationComplete: _handleClassificationResult,
        ),
      ),
    );
  }

  void _navigateToBreeds() {
    // Breeds are already on home screen, or we can navigate to BreedsScreen if needed.
    // Given user instruction, this might be unused or could just scroll to the section.
    // For now, we'll leave it empty or remove if HomeScreen doesn't trigger it.
  }
}