import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import 'models/pending_action.dart';
import 'services/notification_service.dart';

class BootstrapResult {
  BootstrapResult({
    required this.prefs,
    required this.pendingBox,
    required this.notificationService,
  });

  final SharedPreferences prefs;
  final Box<PendingAction> pendingBox;
  final NotificationService notificationService;
}

Future<BootstrapResult> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _ensureFirebaseInitialized();
  final prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(PendingActionAdapter());
  }
  final pendingBox = await Hive.openBox<PendingAction>('pending_actions');
  final notificationService = NotificationService();
  await notificationService.init();
  return BootstrapResult(
    prefs: prefs,
    pendingBox: pendingBox,
    notificationService: notificationService,
  );
}

Future<FirebaseApp> _ensureFirebaseInitialized() async {
  if (Firebase.apps.isNotEmpty) {
    return Firebase.app();
  }

  try {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (error) {
    if (error.code == 'duplicate-app') {
      return Firebase.app();
    }
    rethrow;
  }
}
