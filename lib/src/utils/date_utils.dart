import 'package:intl/intl.dart';
import '../models/role.dart';

String formatDateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date.toUtc());

int calculateStreak(Map<String, Map<String, num>> daily, Role role) {
  final keys = daily.keys.toList()..sort();
  int streak = 0;
  DateTime? expected;
  for (final key in keys.reversed) {
    final date = DateTime.parse(key);
    final value = daily[key]?[role.displayName] ?? 0;
    expected ??= DateTime(date.year, date.month, date.day);
    if (date.isAtSameMomentAs(expected) && value > 0) {
      streak += 1;
      expected = expected.subtract(const Duration(days: 1));
    } else if (value <= 0 || date.isBefore(expected)) {
      break;
    }
  }
  return streak;
}

num weeklySum(Map<String, Map<String, num>> daily, Role role, {int days = 7}) {
  final now = DateTime.now().toUtc();
  final start = now.subtract(Duration(days: days - 1));
  num total = 0;
  daily.forEach((key, value) {
    final date = DateTime.tryParse(key)?.toUtc();
    if (date != null && !date.isBefore(DateTime(start.year, start.month, start.day))) {
      total += value[role.displayName] ?? 0;
    }
  });
  return total;
}

String lastMoveIndicator(Map<String, Map<String, num>> daily, Role role) {
  final keys = daily.keys.toList()..sort();
  if (keys.isEmpty) return 'Belum ada apa-apa. Kita mulai pelan.';
  final latestKey = keys.last;
  final partner = role.partnerName;
  final latestValue = daily[latestKey] ?? {};
  if ((latestValue[partner] ?? 0) > 0) {
    return '$partner baru setor 💧';
  }
  if ((latestValue[role.displayName] ?? 0) > 0) {
    return 'Kamu yang gerak terakhir. Santai.';
  }
  return 'Gerakan terakhir belum tercatat.';
}
