import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/role.dart';
import '../../../models/room_models.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/glass_card.dart';

class AdvancedTracker extends StatelessWidget {
  const AdvancedTracker({super.key, required this.snapshot, required this.role});
  final RoomSnapshot snapshot;
  final Role role;

  @override
  Widget build(BuildContext context) {
    final streak = calculateStreak(snapshot.dailySavings, role);
    final weekly = weeklySum(snapshot.dailySavings, role, days: 7);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ritme 7 & 30 hari', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 160, child: _chart()),
          const SizedBox(height: 8),
          Text('Streak: $streak hari'),
          Text('7 hari terakhir: Rp ${weekly.toStringAsFixed(0)}'),
          Text('⚠️ ${role.partnerName} belum setor hari ini'),
        ],
      ),
    );
  }

  Widget _chart() {
    final now = DateTime.now();
    final spots = <FlSpot>[];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = formatDateKey(date);
      final raw = snapshot.dailySavings[key]?[role.displayName];
      final double val = raw is num ? raw.toDouble() : 0.0;
      spots.add(FlSpot((6 - i).toDouble(), val));
    }
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: const Color(0xFF7A7FFF),
            belowBarData: BarAreaData(show: true, color: const Color(0xFF7A7FFF).withAlpha(51)),
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
