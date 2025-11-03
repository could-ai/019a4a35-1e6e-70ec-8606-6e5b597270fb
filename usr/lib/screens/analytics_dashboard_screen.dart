import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/analytics_model.dart';
import 'package:couldai_user_app/widgets/dynamic_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  late List<AnalyticsData> _filteredData;

  @override
  void initState() {
    super.initState();
    AnalyticsModel.loadSampleData();
    _filteredData = AnalyticsModel.getDataInRange(_startDate, _endDate);
  }

  void _updateDateRange(DateTime start, DateTime end) {
    setState(() {
      _startDate = start;
      _endDate = end;
      _filteredData = AnalyticsModel.getDataInRange(start, end);
    });
  }

  Future<void> _exportCSV() async {
    final csvData = [
      ['Date', 'Total Content', 'Template', 'Engagement', 'Credits', 'Time', 'SEO Score'],
      ..._filteredData.map((d) => [
            DateFormat('yyyy-MM-dd').format(d.date),
            d.totalContentGenerated,
            d.mostUsedTemplate,
            d.userEngagement,
            d.creditsConsumed,
            d.generationTime,
            d.seoScore,
          ]),
    ];
    final csvString = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/analytics.csv');
    await file.writeAsString(csvString);
    await Share.shareXFiles([XFile(file.path)], text: 'Analytics Data');
  }

  @override
  Widget build(BuildContext context) {
    final totalContent = _filteredData.fold(0, (sum, d) => sum + d.totalContentGenerated);
    final avgEngagement = _filteredData.isEmpty ? 0 : _filteredData.map((d) => d.userEngagement).reduce((a, b) => a + b) / _filteredData.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
                      );
                      if (picked != null) _updateDateRange(picked.start, picked.end);
                    },
                    child: const Text('Select Date Range'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _exportCSV, child: const Text('Export CSV')),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Total Content', totalContent.toString()),
                _buildStatCard('Avg Engagement', '${avgEngagement.toFixed(1)}%'),
              ],
            ),
            const SizedBox(height: 20),
            DynamicChart(
              title: 'Content Generation Trends',
              spots: _filteredData.map((d) => FlSpot(d.date.millisecondsSinceEpoch.toDouble(), d.totalContentGenerated.toDouble())).toList(),
            ),
            const SizedBox(height: 20),
            DynamicChart(
              title: 'SEO Scores Over Time',
              spots: _filteredData.map((d) => FlSpot(d.date.millisecondsSinceEpoch.toDouble(), d.seoScore)).toList(),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 14)),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}