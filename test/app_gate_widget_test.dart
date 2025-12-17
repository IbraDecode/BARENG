import 'package:bareng/src/features/gate/app_gate.dart';
import 'package:bareng/src/models/role.dart';
import 'package:bareng/src/services/local_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GatePreview extends ConsumerWidget {
  const GatePreview(this.location, {super.key});
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final redirect = ref.watch(gateProvider.notifier).redirectFor(location) ?? location;
    return Directionality(textDirection: TextDirection.ltr, child: Text(redirect, key: ValueKey(location)));
  }
}

void main() {
  testWidgets('locks flow before welcome', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repo = LocalFlagsRepository(await SharedPreferences.getInstance());
    final notifier = AppGateNotifier(
      repo,
      seed: const LocalFlagState(role: Role.ibra, welcomeDone: false, permissionDone: false, roomId: null, initialized: true),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [gateProvider.overrideWith((ref) => notifier)],
        child: const MaterialApp(home: GatePreview('/home')),
      ),
    );

    expect(find.text('/welcome'), findsOneWidget);
  });
}
