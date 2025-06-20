import 'package:flutter/material.dart';
import 'sentence_screen.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiLingo Home'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          CategoryCard(
            title: '🎯 Quiz Interaktif',
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SentenceScreen()),
            );
            },
          ),
          CategoryCard(
            title: '🧠 Matching Kata',
            onTap: () {
              // TODO: navigate to Matching Screen
            },
          ),
          CategoryCard(
            title: '🎵 Lirik Lagu',
            onTap: () {
              // TODO: navigate to Lirik Lagu Screen
            },
          ),
          CategoryCard(
            title: '📚 Kosakata',
            onTap: () {
        
            },
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.orange.shade100,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
