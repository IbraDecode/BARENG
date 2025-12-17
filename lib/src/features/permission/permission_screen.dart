import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/gate/app_gate.dart';
import '../../services/local_flags.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/primary_button.dart';

class PermissionScreen extends ConsumerStatefulWidget {
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> {
  bool _requested = false;
  bool _requesting = false;

  @override
  void initState() {
    super.initState();
    // Keep observing the gate state so we can push forward once permission flips
    // without relying on the button callback state alone.
    ref.listen<LocalFlagState>(gateProvider, (prev, next) {
      if (!mounted) return;
      if (next.permissionDone) {
        final target = ref.read(gateProvider.notifier).requiredRoute;
        final currentLocation = GoRouter.of(context).location;
        if (currentLocation != target) {
          context.go(target);
        }
      }
    });
  }

  Future<void> _request() async {
    setState(() => _requesting = true);
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      if (!mounted) return;
      setState(() => _requested = granted);
      if (granted) {
        await ref.read(gateProvider.notifier).completePermission();
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gate = ref.watch(gateProvider);
    final granted = _requested || gate.permissionDone;
    if (gate.permissionDone) {
      return const LoadingScreen();
    }
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Notifikasi santai', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  'Supaya kita bisa saling nyolek pelan kalau ada setoran atau malah belum gerak.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(granted ? Icons.notifications_active : Icons.notifications_off,
                        color: granted ? Colors.greenAccent : Colors.amber),
                    const SizedBox(width: 8),
                    Text(granted ? 'OK ✅' : 'BELUM'),
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: _requesting ? 'Sebentar...' : 'Izinkan',
                  onPressed: _request,
                  enabled: !granted && !_requesting,
                ),
                const SizedBox(height: 8),
                Text(
                  'Android 13+ bakal nanya. Kita janji maksimal 2 notif/hari, nggak rese.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
