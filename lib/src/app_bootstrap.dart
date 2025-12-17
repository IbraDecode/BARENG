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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
