import 'package:hive/hive.dart';

part 'pending_action.g.dart';

enum PendingActionType { deposit, createRoom, joinRoom, acknowledge }

@HiveType(typeId: 1)
class PendingAction extends HiveObject {
  PendingAction({
    required this.id,
    required this.type,
    required this.payload,
    required this.createdAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final PendingActionType type;

  @HiveField(2)
  final Map<String, dynamic> payload;

  @HiveField(3)
  final DateTime createdAt;
}
