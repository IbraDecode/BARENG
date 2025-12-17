import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'role.dart';

class RoomMember {
  RoomMember({required this.totalSaved, this.lastActive});
  final num totalSaved;
  final DateTime? lastActive;

  RoomMember copyWith({num? totalSaved, DateTime? lastActive}) {
    return RoomMember(
      totalSaved: totalSaved ?? this.totalSaved,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}

class RoomMeta {
  RoomMeta({required this.targetAmount, required this.createdAt});
  final num targetAmount;
  final DateTime createdAt;
}

class RoomSnapshot {
  RoomSnapshot({
    required this.roomId,
    required this.members,
    required this.dailySavings,
    required this.meta,
  });

  final String roomId;
  final Map<Role, RoomMember> members;
  final Map<String, Map<String, num>> dailySavings; // dateKey -> {Ibra: num, Sinta: num}
  final RoomMeta meta;

  num get totalBoth => members.values.map((m) => m.totalSaved).sum;

  num todayTotal(DateTime today) {
    final key = DateFormat('yyyy-MM-dd').format(today);
    final todayMap = dailySavings[key];
    if (todayMap == null) return 0;
    return todayMap.values.sum;
  }

  num todayFor(Role role, DateTime today) {
    final key = DateFormat('yyyy-MM-dd').format(today);
    return dailySavings[key]?[role.name.capitalized] ?? 0;
  }
}

extension on String {
  String get capitalized => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
