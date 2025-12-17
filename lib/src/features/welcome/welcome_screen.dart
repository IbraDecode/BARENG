import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../features/gate/app_gate.dart';
import '../../widgets/typewriter_text.dart';
import '../../widgets/primary_button.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool textDone = false;

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(gateProvider).role;
    final copy = role == null || role.name == 'ibra'
        ? '“Halo, Tuan.\nSinta udah nunggu. Jangan kelamaan.”'
        : '“Halo, Sinta.\nIni aplikasi kecil buat kita nabung bareng 🤍”';
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/bg_apple.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withAlpha(115)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/robot_3d.json', height: 220, repeat: true),
                        const SizedBox(height: 12),
                        TypewriterText(
                          text: copy,
                          onComplete: () => setState(() => textDone = true),
                        ),
                      ],
                    ),
                  ),
                  PrimaryButton(
                    label: 'Lanjut',
                    enabled: textDone,
                    onPressed: () async {
                      final router = GoRouter.of(context);
                      await ref.read(gateProvider.notifier).completeWelcome();
                      router.go('/permission');
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
