import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/gate/app_gate.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';

class PermissionScreen extends ConsumerStatefulWidget {
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> {
  bool _requested = false;

  Future<void> _request() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    setState(() => _requested = granted);
    if (granted) {
      await ref.read(gateProvider.notifier).completePermission();
      if (mounted) context.go('/pair');
    }
  }

  @override
  Widget build(BuildContext context) {
    final granted = _requested || ref.watch(gateProvider).permissionDone;
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
                PrimaryButton(label: 'Izinkan', onPressed: _request, enabled: !granted),
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
