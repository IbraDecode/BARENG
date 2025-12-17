import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/pending_action.dart';
import 'services/error_notifier.dart';
import 'services/local_flags.dart';
import 'services/notification_service.dart';
import 'services/offline_queue_service.dart';
import 'services/realtime_repository.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences missing override');
});

final pendingBoxProvider = Provider<Box<PendingAction>>((ref) {
  throw UnimplementedError('Pending box missing override');
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError('NotificationService missing override');
});

final errorNotifierProvider = Provider<ErrorNotifier>((ref) {
  throw UnimplementedError('ErrorNotifier missing override');
});

final localFlagsRepositoryProvider = Provider<LocalFlagsRepository>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return LocalFlagsRepository(prefs);
});

final offlineQueueProvider = Provider<OfflineQueueService>((ref) {
  final box = ref.watch(pendingBoxProvider);
  return OfflineQueueService(box: box);
});

final realtimeRepositoryProvider = Provider<RealtimeRepository>((ref) {
  return RealtimeRepository(FirebaseDatabase.instance);
});
