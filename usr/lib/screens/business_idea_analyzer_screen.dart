import 'package:flutter/material.dart';
import 'package:couldai_user_app/widgets/custom_card.dart';

class BusinessIdeaAnalyzerScreen extends StatefulWidget {
  const BusinessIdeaAnalyzerScreen({super.key});

  @override
  State<BusinessIdeaAnalyzerScreen> createState() => _BusinessIdeaAnalyzerScreenState();
}

class _BusinessIdeaAnalyzerScreenState extends State<BusinessIdeaAnalyzerScreen> {
  final TextEditingController _ideaController = TextEditingController();
  bool _isAnalyzing = false;
  String? _analysisResult;

  void _analyzeIdea() {
    if (_ideaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a business idea.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isAnalyzing = false;
        // This would be replaced by the actual API response
        _analysisResult = """
**SWOT Analysis:**
- Strengths: Innovative concept, potential for high market demand.
- Weaknesses: High initial investment, requires specialized skills.
- Opportunities: Growing market, potential for partnerships.
- Threats: Established competitors, changing regulations.

**Porter's Five Forces:**
- Competitive Rivalry: High
- Threat of New Entrants: Medium
- Bargaining Power of Buyers: Medium
- Bargaining Power of Suppliers: Low
- Threat of Substitutes: Low

**PESTEL Analysis:**
- Political: Stable political environment.
- Economic: Favorable economic outlook.
- Social: Growing social acceptance of the technology.
- Technological: Rapid technological advancements.
- Environmental: Minimal environmental impact.
- Legal: Need to comply with data privacy laws.

**Financial Projections:**
- Initial Investment: \$50,000
- Projected Revenue (Year 1): \$120,000
- Break-even Point: 18 months

**Risk Assessment:**
- Market adoption risk: Medium
- Technology risk: Low
- Financial risk: High
""";
      });
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
      appBar: AppBar(
        title: const Text('Business Idea Analyzer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your business idea below to get a comprehensive analysis.',
              style: TextStyle(fontSize: 16),
            ),
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: _isAnalyzing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Analyze Idea', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            if (_analysisResult != null)
              CustomCard(
                title: 'Analysis Results',
                child: Text(
                  _analysisResult!,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
