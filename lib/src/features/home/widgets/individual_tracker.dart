import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/role.dart';
import '../../../models/room_models.dart';
import '../../../widgets/glass_card.dart';

class IndividualTracker extends StatelessWidget {
  const IndividualTracker({super.key, required this.snapshot});
  final RoomSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _userCard(Role.ibra)),
        const SizedBox(width: 12),
        Expanded(child: _userCard(Role.sinta)),
      ],
    );
  }

  Widget _userCard(Role role) {
    final member = snapshot.members[role];
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final today = snapshot.dailySavings[todayKey]?[role.displayName] ?? 0;
    final lastActive = member?.lastActive != null
        ? DateFormat('dd MMM, HH:mm').format(member!.lastActive!.toLocal())
        : 'Belum ada';
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18, backgroundColor: Colors.white12, child: Text(role.displayName[0])),
              const SizedBox(width: 8),
              Text(role.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Total: Rp ${member?.totalSaved.toStringAsFixed(0) ?? '0'}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          Text('Hari ini: Rp ${today.toStringAsFixed(0)}'),
          Text('Last active: $lastActive'),
        ],
      ),
    );
  }
}
