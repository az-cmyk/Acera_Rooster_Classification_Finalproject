import 'package:flutter/material.dart';
import 'rooster_logo.dart';
import 'rooster_breed.dart';
import 'breed_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onClassifyTap;
  final VoidCallback onBreedsTap;

  const HomeScreen({
    super.key,
    required this.onClassifyTap,
    required this.onBreedsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(color: const Color(0xFFF8FAFC)),
        
        SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section with Gradient Mesh
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 40, left: 24, right: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)], // Cyan to Blue
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
                    // Brand
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const RoosterLogo(size: 40),
                        const SizedBox(width: 12),
                        const Text(
                          'Roostify',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Discover Your Rooster\'s Breed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Floating Action Button Style with Gradient
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.white, Color(0xFFF8FAFC)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: onClassifyTap,
                        icon: const Icon(Icons.camera_alt_rounded, color: Color(0xFF06B6D4), size: 24),
                        label: const Text(
                          'Identify Rooster',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF06B6D4),
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Color(0xFF06B6D4),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Identified Classes List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Identified Rooster Breeds',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'All breeds supported by our model',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // List of Breeds
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: RoosterBreed.allBreeds.length,
                      itemBuilder: (context, index) {
                        return BreedCard(breed: RoosterBreed.allBreeds[index]);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Bottom padding
            ],
          ),
        ),
      ],
    );
  }
}