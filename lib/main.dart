import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'src/app_bootstrap.dart';
import 'src/providers.dart';

Future<void> main() async {
  final bootstrapResult = await bootstrap();
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(bootstrapResult.prefs),
        pendingBoxProvider.overrideWithValue(bootstrapResult.pendingBox),
        notificationServiceProvider.overrideWithValue(bootstrapResult.notificationService),
      ],
      child: const BarengApp(),
    ),
  );
}
