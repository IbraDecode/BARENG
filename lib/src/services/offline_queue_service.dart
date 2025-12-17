import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/pending_action.dart';

class OfflineQueueService {
  OfflineQueueService({
    required Box<PendingAction> box,
    Connectivity? connectivity,
  })  : _box = box,
        _connectivity = connectivity ?? Connectivity();

  final Box<PendingAction> _box;
  final Connectivity _connectivity;
  final _uuid = const Uuid();

  Future<PendingAction> enqueue(PendingActionType type, Map<String, dynamic> payload) async {
    final action = PendingAction(
      id: _uuid.v4(),
      type: type,
      payload: payload,
      createdAt: DateTime.now().toUtc(),
    );
    await _box.put(action.id, action);
    return action;
  }

  Future<void> markDone(String id) async {
    await _box.delete(id);
  }

  Iterable<PendingAction> get pending => _box.values;

  Future<void> syncIfOnline(Future<bool> Function(PendingAction action) performer) async {
    final connections = await _connectivity.checkConnectivity();
    if (connections.every((c) => c == ConnectivityResult.none)) return;
    for (final action in List<PendingAction>.from(_box.values)) {
      final success = await performer(action);
      if (success) {
        await markDone(action.id);
      }
    }
  }
}
