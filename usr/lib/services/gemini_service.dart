import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyBCZO4qjarvuaod1YqJyzh9wv_lAE5cy1Y';
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> analyzeBusinessIdea(String idea) async {
    try {
      final prompt = '''Analyze the following business idea comprehensively. Provide detailed insights on:
- SWOT Analysis
- Porter's Five Forces
- PESTEL Analysis
- Financial Projections (initial investment, revenue, break-even)
- Risk Assessment

Business Idea: $idea

Format the response clearly with headings.'';
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Analysis failed.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> generateTrendInsights(String topic) async {
    try {
      final prompt = '''Provide real-time trend analysis for the topic '$topic' across Google, YouTube, Instagram, and TikTok. Include:
- Trending keywords
- Popular content formats
- Optimal posting times
- Content ideas based on current trends

Use AI to analyze internet context.'';
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Trend analysis failed.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> generateCompetitorRecommendations(String keyword) async {
    try {
      final prompt = '''For the keyword '$keyword', provide competitor analysis insights including:
- Top competitors and their domain authority/backlinks
- Content scores and SERP features
- Recommendations to outrank them (e.g., for featured snippets, 'people also ask')

Simulate Semrush/Ahrefs data.'';
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Competitor analysis failed.';
    } catch (e) {
      return 'Error: $e';
    }
  }
}