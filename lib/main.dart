import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'src/app_bootstrap.dart';
import 'src/providers.dart';
import 'src/theme/app_theme.dart';
import 'src/widgets/bootstrap_error_screen.dart';
import 'src/widgets/error_overlay.dart';
import 'src/widgets/loading_screen.dart';
import 'src/services/error_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final errorNotifier = ErrorNotifier();

  void captureError(Object error, StackTrace stackTrace) {
    debugPrint('Caught error: $error');
    debugPrintStack(stackTrace: stackTrace);
    errorNotifier.recordError(error, stackTrace);
  }

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    captureError(details.exception, details.stack ?? StackTrace.current);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    captureError(error, stack);
    return false;
  };

  runZonedGuarded(
    () {
      runApp(
        ProviderScope(
          overrides: [errorNotifierProvider.overrideWithValue(errorNotifier)],
          child: _Bootstrapper(errorNotifier: errorNotifier),
        ),
      );
    },
    (error, stackTrace) {
      captureError(error, stackTrace);
    },
  );
}

class _Bootstrapper extends StatefulWidget {
  const _Bootstrapper({required this.errorNotifier});

  final ErrorNotifier errorNotifier;

  @override
  State<_Bootstrapper> createState() => _BootstrapperState();
}

class _BootstrapperState extends State<_Bootstrapper> {
  Future<BootstrapResult>? _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _startBootstrap();
  }

  Future<BootstrapResult> _attemptBootstrap() async {
    try {
      return await bootstrap();
    } catch (error, stack) {
      widget.errorNotifier.recordError(error, stack);
      rethrow;
    }
  }

  void _startBootstrap() {
    setState(() {
      _bootstrapFuture = _attemptBootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BootstrapResult>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _BootstrapScaffold(child: const LoadingScreen());
        }

        if (snapshot.hasError) {
          return _BootstrapScaffold(
            child: BootstrapErrorScreen(
              message: snapshot.error.toString(),
              onRetry: _startBootstrap,
            ),
          );
        }

        final bootstrapResult = snapshot.data!;
        return ProviderScope(
          overrides: [
            sharedPrefsProvider.overrideWithValue(bootstrapResult.prefs),
            pendingBoxProvider.overrideWithValue(bootstrapResult.pendingBox),
            notificationServiceProvider.overrideWithValue(
              bootstrapResult.notificationService,
            ),
          ],
          child: const BarengApp(),
        );
      },
    );
  }
}

class _BootstrapScaffold extends StatelessWidget {
  const _BootstrapScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bareng',
      debugShowCheckedModeBanner: false,
      theme: BarengTheme.theme,
      builder: (context, innerChild) =>
          ErrorOverlay(child: innerChild ?? child),
      home: child,
    );
  }
}
