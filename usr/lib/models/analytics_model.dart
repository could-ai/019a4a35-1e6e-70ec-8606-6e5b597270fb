class AnalyticsData {
  final DateTime date;
  final int totalContentGenerated;
  final String mostUsedTemplate;
  final double userEngagement;
  final int creditsConsumed;
  final double generationTime;
  final double seoScore;

  AnalyticsData({
    required this.date,
    required this.totalContentGenerated,
    required this.mostUsedTemplate,
    required this.userEngagement,
    required this.creditsConsumed,
    required this.generationTime,
    required this.seoScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'totalContentGenerated': totalContentGenerated,
      'mostUsedTemplate': mostUsedTemplate,
      'userEngagement': userEngagement,
      'creditsConsumed': creditsConsumed,
      'generationTime': generationTime,
      'seoScore': seoScore,
    };
  }

  static AnalyticsData fromMap(Map<String, dynamic> map) {
    return AnalyticsData(
      date: DateTime.parse(map['date']),
      totalContentGenerated: map['totalContentGenerated'],
      mostUsedTemplate: map['mostUsedTemplate'],
      userEngagement: map['userEngagement'],
      creditsConsumed: map['creditsConsumed'],
      generationTime: map['generationTime'],
      seoScore: map['seoScore'],
    );
  }
}

class AnalyticsModel {
  static List<AnalyticsData> _data = [];

  static void addData(AnalyticsData data) {
    _data.add(data);
  }

  static List<AnalyticsData> getData() {
    return _data;
  }

  static List<AnalyticsData> getDataInRange(DateTime start, DateTime end) {
    return _data.where((d) => d.date.isAfter(start.subtract(const Duration(days: 1))) && d.date.isBefore(end.add(const Duration(days: 1)))).toList();
  }

  static void loadSampleData() {
    if (_data.isEmpty) {
      _data = [
        AnalyticsData(date: DateTime.now().subtract(const Duration(days: 7)), totalContentGenerated: 50, mostUsedTemplate: 'Blog Post', userEngagement: 85.0, creditsConsumed: 120, generationTime: 2.5, seoScore: 92.0),
        AnalyticsData(date: DateTime.now().subtract(const Duration(days: 6)), totalContentGenerated: 45, mostUsedTemplate: 'Social Media', userEngagement: 78.0, creditsConsumed: 100, generationTime: 1.8, seoScore: 88.0),
        AnalyticsData(date: DateTime.now().subtract(const Duration(days: 5)), totalContentGenerated: 60, mostUsedTemplate: 'Email', userEngagement: 90.0, creditsConsumed: 150, generationTime: 3.0, seoScore: 95.0),
        AnalyticsData(date: DateTime.now().subtract(const Duration(days: 4)), totalContentGenerated: 55, mostUsedTemplate: 'Blog Post', userEngagement: 82.0, creditsConsumed: 130, generationTime: 2.2, seoScore: 91.0),
        AnalyticsData(date: DateTime.now().subtract(const Duration(days: 3)), totalContentGenerated: 70, mostUsedTemplate: 'Video Script', userEngagement: 87.0, creditsConsumed: 170, generationTime: 4.1, seoScore: 93.0),
        AnalyticsData(date: DateTime.now().subtract(const Duration(days: 2)), totalContentGenerated: 48, mostUsedTemplate: 'Social Media', userEngagement: 79.0, creditsConsumed: 110, generationTime: 2.0, seoScore: 89.0),
        AnalyticsData(date: DateTime.now().subtract(const Duration(days: 1)), totalContentGenerated: 65, mostUsedTemplate: 'Email', userEngagement: 91.0, creditsConsumed: 160, generationTime: 3.5, seoScore: 94.0),
      ];
    }
  }
}