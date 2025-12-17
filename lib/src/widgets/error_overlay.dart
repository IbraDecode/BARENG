import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'glass_card.dart';

class ErrorOverlay extends ConsumerWidget {
  const ErrorOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errors = ref.watch(errorNotifierProvider).errors;
    if (errors.isEmpty) return child;

    return Stack(
      children: [
        child,
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ada yang perlu dilihat pelan-pelan:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...errors
                    .take(3)
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                if (errors.length > 3)
                  Text(
                    '+${errors.length - 3} lagi',
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
