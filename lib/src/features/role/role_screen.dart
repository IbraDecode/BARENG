import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/gate/app_gate.dart';
import '../../models/role.dart';
import '../../widgets/glass_card.dart';

class RoleScreen extends ConsumerStatefulWidget {
  const RoleScreen({super.key});

  @override
  ConsumerState<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends ConsumerState<RoleScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(Role role) async {
    await ref.read(gateProvider.notifier).selectRole(role);
    if (mounted) context.go('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [Colors.white.withAlpha(31), Colors.white.withAlpha(5)],
    );
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F1115), Color(0xFF161A20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pilih peran', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _roleButton(Role.ibra, gradient)),
                      const SizedBox(width: 12),
                      Expanded(child: _roleButton(Role.sinta, gradient)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Dua orang aja. Biar fokus ke kalian.', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleButton(Role role, Gradient gradient) {
    return GestureDetector(
      onTap: () => _select(role),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withAlpha(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.4,
                    child: FractionallySizedBox(
                      widthFactor: 0.8 + (_controller.value * 0.2),
                      heightFactor: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(role.displayName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(role == Role.ibra ? 'Tenang tapi tegas' : 'Lembut tapi solid'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
