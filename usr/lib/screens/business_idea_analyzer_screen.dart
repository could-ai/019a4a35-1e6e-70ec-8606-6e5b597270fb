import 'package:flutter/material.dart';

class BusinessIdeaAnalyzerScreen extends StatelessWidget {
  const BusinessIdeaAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Idea Analyzer'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Coming Soon: Full business idea evaluation framework with SWOT, Porter\'s Five Forces, PESTEL analysis, financial projections, and risk assessment.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
