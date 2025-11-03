import 'package:flutter/material.dart';

class CompetitorAnalysisScreen extends StatelessWidget {
  const CompetitorAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competitor Analysis'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Coming Soon: Advanced competitor analysis using Semrush/Ahrefs data to provide insights on keywords, backlinks, and content strategies.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
