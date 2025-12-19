import 'dart:io';
import 'package:flutter/material.dart';
import 'rooster_breed.dart';

class BreedDetailScreen extends StatelessWidget {
  final RoosterBreed breed;

  const BreedDetailScreen({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF06B6D4),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'breed_${breed.name}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    breed.imageUrl.startsWith('http')
                        ? Image.network(breed.imageUrl, fit: BoxFit.cover)
                        : Image.asset(breed.imageUrl, fit: BoxFit.cover),
                    // Gradient for text readability
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
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.public, color: Color(0xFF64748B), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        breed.origin,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    breed.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildSectionTitle('Description'),
                  const SizedBox(height: 8),
                  Text(
                    breed.description, // In a real app, this might be a longer bio
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF334155),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Key Characteristics'),
                  const SizedBox(height: 12),
                  ...breed.characteristics.map((char) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF06B6D4), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            char,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0F172A),
      ),
    );
  }
}
