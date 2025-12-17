import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/router/app_router.dart';
import 'src/theme/app_theme.dart';
import 'src/widgets/error_overlay.dart';

class BarengApp extends ConsumerWidget {
  const BarengApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Bareng',
      debugShowCheckedModeBanner: false,
      theme: BarengTheme.theme,
      builder: (context, child) =>
          ErrorOverlay(child: child ?? const SizedBox.shrink()),
      routerConfig: router,
    );
  }
}
