import 'dart:io';
import 'package:flutter/material.dart';
import 'analytics_widgets.dart';
import 'rooster_breed.dart';

class ResultScreen extends StatelessWidget {
  final String breedName;
  final double confidence;
  final String imagePath;
  final List<dynamic> allScores;
  final List<String> allLabels;
  
  const ResultScreen({
    super.key,
    required this.breedName,
    required this.confidence,
    required this.imagePath,
    required this.allScores,
    required this.allLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Immersive Header
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFF06B6D4),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                  // Confidence Badge pinned to image
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00C853).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${confidence.toStringAsFixed(0)}% Confidence',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Identified Breed',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    breedName,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Analytics Button with Gradient
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF06B6D4).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AnalyticsModal(
                            scores: allScores, 
                            labels: allLabels
                          ),
                        );
                      },
                      icon: const Icon(Icons.insights_rounded, size: 24),
                      label: const Text(
                        'View Live Analysis',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.info_outline_rounded, color: Color(0xFF64748B)),
                            SizedBox(width: 12),
                            Text(
                              'About this Result',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Builder(
                          builder: (context) {
                            // Find the breed info from the static list
                            final breed = RoosterBreed.allBreeds.firstWhere(
                              (b) => b.name.toLowerCase() == breedName.toLowerCase(),
                              orElse: () => RoosterBreed(
                                name: breedName, 
                                scientificName: '', // Added missing required arg
                                imageUrl: '', // Fixed missing/wrong arg name mapping if any
                                origin: 'Unknown', 
                                description: 'The model analyzed this image and extracted specific features matching the $breedName breed profile.', 
                                characteristics: ['Unique plumage', 'Distinctive shape']
                              ),
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Reference Image if available
                                if (breed.imageUrl.isNotEmpty && breed.origin != 'Unknown')
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    height: 180,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: AssetImage(breed.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                
                                Text(
                                  breed.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                    height: 1.6,
                                  ),
                                ),
                                if (breed.origin != 'Unknown') ...[
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Key Characteristics:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...breed.characteristics.map((char) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('• ', style: TextStyle(color: Color(0xFF64748B))),
                                        Expanded(
                                          child: Text(
                                            char,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                                ],
                              ],
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}