import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsModal extends StatelessWidget {
  final List<dynamic> scores;
  final List<String> labels;

  const AnalyticsModal({
    super.key,
    required this.scores,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    // Combine labels and scores
    final List<Map<String, dynamic>> data = [];
    for (int i = 0; i < scores.length; i++) {
      if (i < labels.length) {
        data.add({
          'label': labels[i],
          'score': (scores[i] as num).toDouble(),
        });
      }
    }

    // Sort descending
    data.sort((a, b) =>
        (b['score'] as double).compareTo(a['score'] as double));

    // Filter out zero scores for clearer analysis, but keep at least one
    final relevantData = data.where((e) => (e['score'] as double) > 0.0).toList();
    if (relevantData.isEmpty && data.isNotEmpty) {
      relevantData.add(data.first);
    }

    final topResult =
        relevantData.isNotEmpty ? relevantData[0] : {'label': 'N/A', 'score': 0.0};
        
    final topScore = topResult['score'] as double;
    
    // Determine status and dynamic color for the card
    // default (high) = Green-ish mix
    // medium = Yellow/Orange mix
    // low = Red/Orange mix
    
    List<Color> cardGradient;
    Color shadowColor;
    
    if (topScore > 0.8) {
      // High - Green/Teal
      cardGradient = [const Color(0xFF10B981), const Color(0xFF059669)];
      shadowColor = const Color(0xFF10B981);
    } else if (topScore > 0.5) {
      // Medium - Yellow/Orange (Gold)
      cardGradient = [const Color(0xFFF59E0B), const Color(0xFFD97706)];
      shadowColor = const Color(0xFFF59E0B);
    } else {
      // Low - Red/Rose
      cardGradient = [const Color(0xFFEF4444), const Color(0xFFB91C1C)];
      shadowColor = const Color(0xFFEF4444);
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analysis Results',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // 1. Simpler "Best Match" Card
                _buildBestMatchCard(topResult, cardGradient, shadowColor),
                
                const SizedBox(height: 32),

                // 2. Bar Chart
                if (relevantData.length > 1) ...[
                  _sectionHeader(
                    'Top Possibilities', 
                    Icons.bar_chart,
                    infoText: 'Comparison of top matches only',
                  ),
                  const SizedBox(height: 16),
                  _buildBarChart(relevantData),
                  const SizedBox(height: 32),
                ],

                // 3. Clear Section Header
                if (relevantData.length > 1) ...[
                  _sectionHeader('Other Possibilities', Icons.list_alt),
                  const SizedBox(height: 16),
                  
                  // 4. The List (Skip the first one since it's in the Best Match card)
                  _buildBreakdownList(relevantData.skip(1).toList()),
                ] else ...[
                   const SizedBox(height: 8),
                   const Text(
                     "No other significant matches found.",
                     textAlign: TextAlign.center,
                     style: TextStyle(color: Colors.grey),
                   ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestMatchCard(Map<String, dynamic> topResult, List<Color> gradient, Color shadowColor) {
    final score = topResult['score'] as double;
    final percentage = (score * 100).toStringAsFixed(1);
    
    String status;
    Color statusColor;
    if (score > 0.8) {
      status = "High Confidence";
      statusColor = Colors.white;
    } else if (score > 0.5) {
      status = "Moderate Confidence";
      statusColor = Colors.white.withOpacity(0.9);
    } else {
      status = "Low Confidence – possible mix";
      statusColor = Colors.white.withOpacity(0.9);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Best Match',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: "Confidence shows how closely the image matches known breed features.",
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(Icons.info_outline, size: 16, color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            topResult['label'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, {String? infoText}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF475569)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  if (infoText != null) ...[
                    const SizedBox(width: 8),
                    Tooltip(
                      message: infoText,
                      triggerMode: TooltipTriggerMode.tap,
                      child: const Icon(Icons.info_outline, size: 18, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ],
              ),
              if (infoText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    infoText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(List<Map<String, dynamic>> data) {
    // Take top 5 for the chart
    final chartData = data.take(5).toList();
    
    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(16, 24, 24, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 0.25,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < chartData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 0.25,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value == 0 || value == 0.25 || value == 0.5 || value == 0.75 || value == 1.0) {
                     return Text(
                      '${(value * 100).toInt()}%',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 10,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          maxY: 1.05,
          barGroups: chartData.asMap().entries.map((e) {
            final index = e.key;
            final score = e.value['score'] as double;
            final isTop = index == 0;
            
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: score,
                  color: isTop ? const Color(0xFF06B6D4) : const Color(0xFF94A3B8),
                  width: 20,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 1.0,
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
              ],
            );
          }).toList(),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => const Color(0xFF1E293B),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final label = chartData[group.x.toInt()]['label'];
                  final score = (rod.toY * 100).toStringAsFixed(1);
                  return BarTooltipItem(
                    '$label\n$score%',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownList(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
       return const Center(
         child: Text('No other significant matches found.'),
       );
    }
    
    return Column(
      children: data.map((item) {
        final double score = item['score'];
        // Since these are "other possibilities", they won't be "High" (green/blue) usually, 
        // but we keep the visual logic simple.
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              // Circular percentage indicator
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  children: [
                    Center(
                      child: CircularProgressIndicator(
                        value: score,
                        backgroundColor: const Color(0xFFF1F5F9),
                        color: const Color(0xFF64748B),
                        strokeWidth: 4,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${(score * 100).toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['label'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${(score * 100).toStringAsFixed(1)}% match',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
