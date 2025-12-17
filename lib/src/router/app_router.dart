import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/gate/app_gate.dart';
import '../features/home/home_screen.dart';
import '../features/pairing/pairing_screen.dart';
import '../features/permission/permission_screen.dart';
import '../features/role/role_screen.dart';
import '../features/welcome/welcome_screen.dart';
import '../widgets/loading_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/loading',
    refreshListenable: GoRouterRefreshStream(ref.watch(gateProvider.notifier).stream),
    redirect: (context, state) {
      final location = state.uri.path;
      final redirect = ref.read(gateProvider.notifier).redirectFor(location);
      if (redirect != null && redirect != location) return redirect;
      return null;
    },
    routes: [
      GoRoute(path: '/loading', builder: (context, state) => const LoadingScreen()),
      GoRoute(path: '/role', builder: (context, state) => const RoleScreen()),
      GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: '/permission', builder: (context, state) => const PermissionScreen()),
      GoRoute(path: '/pair', builder: (context, state) => const PairingScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
