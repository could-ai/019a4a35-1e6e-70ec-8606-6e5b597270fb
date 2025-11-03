import 'package:flutter/material.dart';
import 'package:couldai_user_app/services/gemini_service.dart';
import 'package:couldai_user_app/widgets/custom_card.dart';
import 'package:couldai_user_app/widgets/dynamic_chart.dart';
import 'package:couldai_user_app/widgets/data_input_form.dart';
import 'package:fl_chart/fl_chart.dart';

class BusinessIdeaAnalyzerScreen extends StatefulWidget {
  const BusinessIdeaAnalyzerScreen({super.key});

  @override
  State<BusinessIdeaAnalyzerScreen> createState() => _BusinessIdeaAnalyzerScreenState();
}

class _BusinessIdeaAnalyzerScreenState extends State<BusinessIdeaAnalyzerScreen> {
  final TextEditingController _ideaController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  bool _isAnalyzing = false;
  String? _analysisResult;
  Map<String, dynamic>? _financialData;

  void _analyzeIdea() async {
    if (_ideaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a business idea.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
      _financialData = null;
    });

    final result = await _geminiService.analyzeBusinessIdea(_ideaController.text);
    setState(() {
      _isAnalyzing = false;
      _analysisResult = result;
      _financialData = {
        'investment': 50000,
        'revenue': [120000, 150000, 180000], // Simulated projections
        'risk': [30, 20, 10], // Simulated risk levels
      };
    });
  }

  void _onScenarioSubmit(Map<String, dynamic> data) {
    // Update financial data based on user input (e.g., sliders for scenarios)
    setState(() {
      _financialData = {
        'investment': int.tryParse(data['Initial Investment'] ?? '50000') ?? 50000,
        'revenue': [int.tryParse(data['Year 1 Revenue'] ?? '120000') ?? 120000, 150000, 180000],
        'risk': [20, 15, 5], // Updated based on scenario
      };
    });
  }

  @override
  void dispose() {
    _ideaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Idea Analyzer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter your business idea below for comprehensive analysis.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: _ideaController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Describe your business idea',
                hintText: 'e.g., A subscription service for eco-friendly pet toys.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isAnalyzing ? null : _analyzeIdea,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16.0)),
              child: _isAnalyzing ? const CircularProgressIndicator(color: Colors.white) : const Text('Analyze Idea', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            if (_analysisResult != null) CustomCard(title: 'Analysis Results', child: Text(_analysisResult!, style: const TextStyle(fontSize: 16, height: 1.5))),
            const SizedBox(height: 20),
            if (_financialData != null) ...[
              CustomCard(
                title: 'Financial Projections',
                child: DynamicChart(
                  title: 'Revenue Projection',
                  spots: [
                    FlSpot(1, _financialData!['revenue'][0].toDouble()),
                    FlSpot(2, _financialData!['revenue'][1].toDouble()),
                    FlSpot(3, _financialData!['revenue'][2].toDouble()),
                  ],
                ),
              ),
              CustomCard(
                title: 'Risk Assessment',
                child: DynamicChart(
                  title: 'Risk Levels',
                  spots: [
                    FlSpot(1, _financialData!['risk'][0].toDouble()),
                    FlSpot(2, _financialData!['risk'][1].toDouble()),
                    FlSpot(3, _financialData!['risk'][2].toDouble()),
                  ],
                  color: Colors.red,
                ),
              ),
              CustomCard(
                title: 'Input Scenarios',
                child: DataInputForm(
                  fields: ['Initial Investment', 'Year 1 Revenue'],
                  onSubmit: _onScenarioSubmit,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}