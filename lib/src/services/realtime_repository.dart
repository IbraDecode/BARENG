import 'package:firebase_database/firebase_database.dart' as rtdb;
import '../models/room_models.dart';
import '../models/role.dart';
import '../utils/date_utils.dart';

class RealtimeRepository {
  RealtimeRepository(this._db);
  final rtdb.FirebaseDatabase _db;

  rtdb.DatabaseReference get roomsRef => _db.ref('rooms');

  Future<String> createRoom(Role role, {num targetAmount = 15000000}) async {
    final newRoom = roomsRef.push();
    final now = rtdb.ServerValue.timestamp;
    await newRoom.set({
      'members': {
        role.displayName: {
          'totalSaved': 0,
          'lastActive': now,
        }
      },
      'savings': {
        'daily': {},
      },
      'meta': {
        'targetAmount': targetAmount,
        'createdAt': now,
      }
    });
    return newRoom.key!;
  }

  Future<bool> joinRoom(String roomId, Role role) async {
    final ref = roomsRef.child(roomId);
    final snapshot = await ref.get();
    if (!snapshot.exists) return false;
    final members = (snapshot.child('members').value as Map?) ?? {};
    if (members.length >= 2 && !members.containsKey(role.displayName)) {
      return false;
    }
    await ref.child('members/${role.displayName}').set({
      'totalSaved': members[role.displayName]?['totalSaved'] ?? 0,
      'lastActive': rtdb.ServerValue.timestamp,
    });
    return true;
  }

  Stream<RoomSnapshot> watchRoom(String roomId) {
    return roomsRef.child(roomId).onValue.map((event) {
      final data = (event.snapshot.value as Map?) ?? {};
      final membersMap = (data['members'] as Map?) ?? {};
      final savings = Map<String, Map<String, num>>.from(
        ((data['savings']?['daily']) as Map?)?.map(
              (key, value) => MapEntry(
                key as String,
                Map<String, num>.from(value as Map? ?? {}),
              ),
            ) ??
            {},
      );
      final members = <Role, RoomMember>{};
      membersMap.forEach((key, value) {
        final role = key == 'Ibra' ? Role.ibra : Role.sinta;
        members[role] = RoomMember(
          totalSaved: (value['totalSaved'] ?? 0) as num,
      lastActive: value['lastActive'] != null
          ? DateTime.fromMillisecondsSinceEpoch(value['lastActive']).toUtc()
          : null,
        );
      });
      final metaRaw = data['meta'] as Map? ?? {};
      return RoomSnapshot(
        roomId: roomId,
        members: members,
        dailySavings: savings,
        meta: RoomMeta(
          targetAmount: (metaRaw['targetAmount'] ?? 0) as num,
          createdAt: metaRaw['createdAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(metaRaw['createdAt']).toUtc()
              : DateTime.now().toUtc(),
        ),
      );
    });
  }

  Future<bool> addDeposit(String roomId, Role role, num amount) async {
    final roomRef = roomsRef.child(roomId);
    final dateKey = formatDateKey(DateTime.now());
    final memberKey = role.displayName;
    return roomRef.runTransaction((mutableData) {
      final data = ((mutableData as dynamic).value as Map?) ?? {};
      final members = (data['members'] as Map?) ?? {};
      final targetMember = (members[memberKey] as Map?) ?? {};
      final newTotal = (targetMember['totalSaved'] ?? 0) + amount;
      final savings = (data['savings'] as Map?) ?? {};
      final daily = (savings['daily'] as Map?) ?? {};
      final todays = (daily[dateKey] as Map?) ?? {};
      todays[memberKey] = (todays[memberKey] ?? 0) + amount;
      daily[dateKey] = todays;
      members[memberKey] = {
        'totalSaved': newTotal,
        'lastActive': rtdb.ServerValue.timestamp,
      };
      data['members'] = members;
      data['savings'] = {'daily': daily};
      (mutableData as dynamic).value = data;
      return rtdb.Transaction.success(mutableData);
    }).then((value) => value.committed);
  }
}
