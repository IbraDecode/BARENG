import 'package:bareng/src/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bareng/src/models/role.dart';

void main() {
  test('formatDateKey returns yyyy-MM-dd in UTC', () {
    final date = DateTime.utc(2024, 12, 31, 23, 59);
    expect(formatDateKey(date), '2024-12-31');
  });

  test('calculateStreak counts consecutive days with deposits', () {
    final data = {
      '2024-12-30': {'Ibra': 1000, 'Sinta': 0},
      '2024-12-29': {'Ibra': 2000, 'Sinta': 0},
      '2024-12-27': {'Ibra': 1000, 'Sinta': 0},
    };
    expect(calculateStreak(data, Role.ibra), 2);
    expect(calculateStreak(data, Role.sinta), 0);
  });
}
