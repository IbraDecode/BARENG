import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers.dart';
import '../../features/gate/app_gate.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';

class PairingScreen extends ConsumerStatefulWidget {
  const PairingScreen({super.key});

  @override
  ConsumerState<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends ConsumerState<PairingScreen> {
  final _controller = TextEditingController();
  String _status = '';
  bool _loading = false;

  Future<void> _createRoom() async {
    setState(() {
      _loading = true;
      _status = 'Bikin ruang kecil kamu...';
    });
    final role = ref.read(gateProvider).role;
    if (role == null) return;
    final repo = ref.read(realtimeRepositoryProvider);
    final roomId = await repo.createRoom(role);
    await ref.read(gateProvider.notifier).setRoom(roomId);
    setState(() {
      _loading = false;
      _status = 'Ruang jadi. Bagikan kode: $roomId';
    });
    if (mounted) context.go('/home');
  }

  Future<void> _joinRoom() async {
    setState(() {
      _loading = true;
      _status = 'Cek ruang...';
    });
    final roomId = _controller.text.trim();
    final role = ref.read(gateProvider).role;
    if (role == null) return;
    final repo = ref.read(realtimeRepositoryProvider);
    final ok = await repo.joinRoom(roomId, role);
    setState(() {
      _loading = false;
      _status = ok ? 'Nyambung! Kamu udah berdua.' : 'Ruang penuh / nggak ada';
    });
    if (ok) {
      await ref.read(gateProvider.notifier).setRoom(roomId);
      if (mounted) context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Pairing', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Kode cuma untuk kalian berdua. 1 room = 2 orang, titik.'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode',
                      filled: true,
                      fillColor: Colors.white.withAlpha(20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: PrimaryButton(label: 'Buat Room', onPressed: _createRoom, enabled: !_loading)),
                      const SizedBox(width: 12),
                      Expanded(child: PrimaryButton(label: 'Gabung', onPressed: _joinRoom, enabled: !_loading)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _loading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        : Text(_status, key: ValueKey(_status)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                children: const [
                  Text('Room info'),
                  SizedBox(height: 6),
                  Text('Realtime, max 2 member. Kalau penuh, tolak otomatis.'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
