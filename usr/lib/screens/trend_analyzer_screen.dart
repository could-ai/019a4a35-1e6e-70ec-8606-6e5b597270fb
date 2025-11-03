import 'package:flutter/material.dart';
import 'package:couldai_user_app/services/gemini_service.dart';
import 'package:couldai_user_app/services/trend_service.dart';
import 'package:couldai_user_app/widgets/custom_card.dart';

class TrendAnalyzerScreen extends StatefulWidget {
  const TrendAnalyzerScreen({super.key});

  @override
  State<TrendAnalyzerScreen> createState() => _TrendAnalyzerScreenState();
}

class _TrendAnalyzerScreenState extends State<TrendAnalyzerScreen> {
  final TextEditingController _topicController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  bool _isAnalyzing = false;
  String? _trendResult;
  Map<String, dynamic>? _platformData;

  void _analyzeTrends() async {
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a topic.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _trendResult = null;
      _platformData = null;
    });

    final aiInsights = await _geminiService.generateTrendInsights(_topicController.text);
    final platformData = await TrendService.fetchTrends(_topicController.text);

    setState(() {
      _isAnalyzing = false;
      _trendResult = aiInsights;
      _platformData = platformData;
    });
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trend Analyzer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter a topic to get real-time trend analysis across platforms.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(
                labelText: 'Topic',
                hintText: 'e.g., Sustainable fashion.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isAnalyzing ? null : _analyzeTrends,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16.0)),
              child: _isAnalyzing ? const CircularProgressIndicator(color: Colors.white) : const Text('Analyze Trends', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            if (_trendResult != null) CustomCard(title: 'AI-Powered Insights', child: Text(_trendResult!, style: const TextStyle(fontSize: 16, height: 1.5))),
            const SizedBox(height: 20),
            if (_platformData != null && !_platformData!.containsKey('error')) ...[
              CustomCard(title: 'Platform Trends', child: Column(
                children: _platformData!.entries.map((entry) => ListTile(
                  title: Text(entry.key.toUpperCase()),
                  subtitle: Text(entry.value.toString()),
                )).toList(),
              )),
            ],
          ],
        ),
      ),
    );
  }
}