import 'package:flutter/material.dart';
import 'package:couldai_user_app/services/competitor_service.dart';
import 'package:couldai_user_app/services/gemini_service.dart';
import 'package:couldai_user_app/widgets/custom_card.dart';

class CompetitorAnalysisScreen extends StatefulWidget {
  const CompetitorAnalysisScreen({super.key});

  @override
  State<CompetitorAnalysisScreen> createState() => _CompetitorAnalysisScreenState();
}

class _CompetitorAnalysisScreenState extends State<CompetitorAnalysisScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _keywordController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisData;
  String? _recommendations;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _analyzeKeyword() async {
    if (_keywordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a keyword.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisData = null;
      _recommendations = null;
    });

    final data = await CompetitorService.analyzeKeyword(_keywordController.text);
    final recs = await _geminiService.generateCompetitorRecommendations(_keywordController.text);

    setState(() {
      _isAnalyzing = false;
      _analysisData = data;
      _recommendations = recs;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competitor Analysis'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Keyword Analysis'),
            Tab(text: 'Recommendations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Enter a keyword to analyze competitors and SEO metrics.', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                TextField(
                  controller: _keywordController,
                  decoration: const InputDecoration(
                    labelText: 'Keyword',
                    hintText: 'e.g., eco-friendly products.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isAnalyzing ? null : _analyzeKeyword,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16.0)),
                  child: _isAnalyzing ? const CircularProgressIndicator(color: Colors.white) : const Text('Analyze', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
                if (_analysisData != null) CustomCard(
                  title: 'Analysis Results',
                  child: Column(
                    children: [
                      Text('Difficulty: ${_analysisData!['keywordDifficulty']}'),
                      ...(_analysisData!['competitors'] as List).map((comp) => ListTile(
                        title: Text(comp['name']),
                        subtitle: Text('DA: ${comp['domainAuthority']}, Backlinks: ${comp['backlinks']}, Score: ${comp['contentScore']}'),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _recommendations != null ? CustomCard(title: 'Outranking Recommendations', child: Text(_recommendations!, style: const TextStyle(fontSize: 16, height: 1.5))) : const Center(child: Text('Analyze a keyword first.')),
          ),
        ],
      ),
    );
  }
}