import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
        final currentLocation = _currentLocation(context);
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
      final granted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;
      if (!mounted) return;
      setState(() => _requested = granted);
      if (granted) {
        await ref.read(gateProvider.notifier).completePermission();
      }
    } catch (err, stack) {
      debugPrint('permission request failed: $err\n$stack');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lagi kesenggol, coba lagi pelan-pelan ya.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg_apple.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.45),
              colorBlendMode: BlendMode.srcOver,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xCC0C121A), Color(0xAA0B1625)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: const Text('Langkah 3 dari 5 · Permission'),
                      ),
                      const Spacer(),
                      _statusChip(granted),
                    ],
                  ),
                  const SizedBox(height: 18),
                  GlassCard(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue.withValues(alpha: 0.16),
                                Colors.purple.withValues(alpha: 0.12),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Lottie.asset(
                              'assets/robot_3d.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Robot lembut yang nggak bakal cerewet.',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Dia cuma muncul untuk tiga hal: ngingetin setoran, nunjukin apresiasi kecil, atau nanya kabar kalau salah satu dari kita tiba-tiba diam.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: const [
                                  _SoftPill(label: 'max 2 notif/hari'),
                                  _SoftPill(label: 'tanpa iklan'),
                                  _SoftPill(label: 'hanya untuk kita berdua'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apa yang akan terjadi setelah kamu tekan Izinkan?',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        _StepRow(
                          index: 1,
                          title: 'Kita kunci janji harian',
                          detail:
                              'Ritual setor jadi lebih terasa karena dua-duanya dapat pengingat yang sama lembutnya.',
                        ),
                        const SizedBox(height: 10),
                        _StepRow(
                          index: 2,
                          title: 'Pairing lanjut otomatis',
                          detail:
                              'Begitu izin selesai, kita langsung lanjut ke layar pairing tanpa blank screen.',
                        ),
                        const SizedBox(height: 10),
                        _StepRow(
                          index: 3,
                          title: 'Home tenang',
                          detail:
                              'Home tetap glassy dengan quick action bulat, saldo duet, dan copy lembut di bawahnya.',
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                label: _requesting
                                    ? 'Sebentar...'
                                    : 'Izinkan notifikasi lembut',
                                onPressed: _request,
                                enabled: !granted && !_requesting,
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              tooltip: 'Lihat dulu',
                              onPressed: granted ? null : _showPromise,
                              icon: const Icon(Icons.info_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Android 13+ bakal munculin dialog sistem. Kita nggak akan spam — paling sering dua kali sehari, selebihnya cuma diam menemani.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _currentLocation(BuildContext context) {
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration;
    if (matches.isNotEmpty) {
      return matches.last.matchedLocation;
    }
    final info = router.routeInformationProvider.value;
    return info.uri.toString();
  }

  Widget _statusChip(bool granted) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (granted ? Colors.green : Colors.amber).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(granted ? Icons.check_rounded : Icons.notifications_off,
              color: granted ? Colors.greenAccent : Colors.amber),
          const SizedBox(width: 6),
          Text(granted ? 'Sudah diizinkan' : 'Belum diizinkan'),
        ],
      ),
    );
  }

  void _showPromise() {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Janji notifikasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12),
              Text('• Maksimal dua kali sehari, sisanya diam'),
              SizedBox(height: 6),
              Text('• Nggak ada promosi atau iklan'),
              SizedBox(height: 6),
              Text('• Hanya muncul buat dua orang: Ibra & Sinta'),
              SizedBox(height: 16),
              Text(
                  'Kalau ragu, tekan Izinkan nanti saja. Aplikasi tetap bisa dibuka tanpa blank screen.'),
            ],
          ),
        );
      },
    );
  }
}

class _SoftPill extends StatelessWidget {
  const _SoftPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow(
      {required this.index, required this.title, required this.detail});
  final int index;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent.withValues(alpha: 0.12),
          ),
          child: Text('$index',
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(detail),
            ],
          ),
        ),
      ],
    );
  }
}
