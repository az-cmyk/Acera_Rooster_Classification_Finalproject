import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'rooster_logo.dart';
import 'firestore_service.dart';

class ClassificationScreen extends StatefulWidget {
  final Function(String) onImageSelected;
  final Function(Map<String, dynamic>) onClassificationComplete;

  const ClassificationScreen({
    super.key,
    required this.onImageSelected,
    required this.onClassificationComplete,
  });

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isProcessing = false;

  Interpreter? _interpreter;
  List<String> _labels = [];
  final FirestoreService _firestoreService = FirestoreService();

  static const int inputSize = 224;
  static const double confidenceThreshold = 0.6;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/model_unquant.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      _interpreter!.allocateTensors();
    } catch (e) {
      debugPrint('Error loading model: $e');
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelsData =
          await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelsData
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('Error loading labels: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });

    widget.onImageSelected(image.path);
    await _classifyImage();
  }

  Future<void> _classifyImage() async {
    if (_selectedImage == null ||
        _interpreter == null ||
        _labels.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final imageBytes = await _selectedImage!.readAsBytes();
      var image = img.decodeImage(imageBytes);
      if (image == null) return;

      image = img.bakeOrientation(image);

      final resized =
          img.copyResizeCropSquare(image, size: inputSize);

      final rgbBytes =
          resized.getBytes(order: img.ChannelOrder.rgb);

      final input = Float32List(inputSize * inputSize * 3);

      for (int i = 0; i < rgbBytes.length; i++) {
        input[i] = (rgbBytes[i] - 127.5) / 127.5;
      }

      final inputTensor =
          input.reshape([1, inputSize, inputSize, 3]);
      final outputTensor =
          List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

      _interpreter!.run(inputTensor, outputTensor);

      final scores =
          (outputTensor[0] as List).cast<double>();

      final results = List.generate(
        _labels.length,
        (i) => {
          'label': _labels[i],
          'score': scores[i],
        },
      );

      results.sort(
        (a, b) =>
            (b['score'] as double).compareTo(a['score'] as double),
      );

      final best = results.first;
      final bestScore = best['score'] as double;
      final bestLabel = best['label'] as String;

      if (bestScore < confidenceThreshold) {
        widget.onClassificationComplete({
          'class': 'Uncertain',
          'confidence': bestScore * 100,
          'top3': results.take(3).toList(),
          'scores': scores,
          'labels': _labels,
        });
      } else {
        widget.onClassificationComplete({
          'class': bestLabel,
          'confidence': (bestScore * 100).clamp(0, 99.9),
          'top3': results.take(3).toList(),
          'scores': scores,
          'labels': _labels,
        });

        await _firestoreService.logClassification(
          breedName: bestLabel,
          confidence: (bestScore * 100).clamp(0, 99.9),
          top3: results.take(3).toList(),
        );
      }
    } catch (e) {
      debugPrint('Classification error: $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcessing) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF00BCD4)),
              SizedBox(height: 16),
              Text(
                'Analyzing...',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header Section with Gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 40, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)], // Gradient matching Home Screen
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x3306B6D4),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Custom Navigation Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Text(
                      'Identify Rooster',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 24), // To balance the back button
                  ],
                ),
                const SizedBox(height: 24),
                
                // Logo Section
                const RoosterLogo(size: 80, color: Colors.white),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'AI-Powered Detection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Select an Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose a method to identify your rooster',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Action Cards
                  Row(
                    children: [
                      Expanded(
                        child: _actionCard(
                          icon: Icons.camera_alt_rounded,
                          label: 'Camera',
                          color: const Color(0xFF06B6D4),
                          onTap: () => _pickImage(ImageSource.camera),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _actionCard(
                          icon: Icons.photo_library_rounded,
                          label: 'Gallery',
                          color: const Color(0xFF7C4DFF),
                          onTap: () => _pickImage(ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  // Tips
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Color(0xFF64748B)),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'For best results, ensure the rooster is centered and well-lit.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.05),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 160,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
