import 'package:flutter/material.dart';

class TrendAnalyzerScreen extends StatelessWidget {
  const TrendAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trend Analyzer'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Coming Soon: Real-time trend analysis for Google, YouTube, Instagram, and TikTok to identify market opportunities.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
