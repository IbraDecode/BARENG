import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../models/day_state.dart';
import '../../models/event_prompt.dart';
import '../../models/pending_action.dart';
import '../../models/robot_mood.dart';
import '../../models/role.dart';
import '../../models/room_models.dart';
import '../../providers.dart';
import '../../utils/date_utils.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/quick_action_button.dart';
import '../gate/app_gate.dart';
import 'widgets/advanced_tracker.dart';
import 'widgets/individual_tracker.dart';

final roomStreamProvider = StreamProvider.autoDispose<RoomSnapshot?>((ref) {
  final roomId = ref.watch(gateProvider).roomId;
  if (roomId == null) return const Stream.empty();
  return ref.watch(realtimeRepositoryProvider).watchRoom(roomId);
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ConfettiController _confetti;
  bool hideAmount = false;
  String statusCopy = '';
  bool _tokenSaved = false;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _depositQuick(num amount) async {
    final role = ref.read(gateProvider).role;
    final roomId = ref.read(gateProvider).roomId;
    if (role == null || roomId == null) return;
    final repo = ref.read(realtimeRepositoryProvider);
    final queue = ref.read(offlineQueueProvider);
    try {
      final ok = await repo.addDeposit(roomId, role, amount);
      if (ok) {
        _confetti.play();
        setState(
          () =>
              statusCopy = 'Terekam. ${role.partnerName} bakal lihat realtime.',
        );
      }
    } catch (_) {
      await queue.enqueue(PendingActionType.deposit, {
        'roomId': roomId,
        'role': role.displayName,
        'amount': amount,
      });
      setState(
        () => statusCopy = 'Offline. Kita simpan dulu, nanti disinkron.',
      );
    }
    await queue.syncIfOnline((action) async {
      if (action.type != PendingActionType.deposit) return true;
      final role = action.payload['role'] == 'Ibra' ? Role.ibra : Role.sinta;
      final amount = action.payload['amount'] as num;
      return repo.addDeposit(action.payload['roomId'] as String, role, amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(gateProvider).role ?? Role.ibra;
    final roomAsync = ref.watch(roomStreamProvider);
    final greeting = 'Halo, ${role.displayName}';
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0E1014), Color(0xFF151924)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: roomAsync.when(
              data: (snapshot) {
                if (snapshot == null) {
                  return _failsafe('Belum ada apa-apa. Kita mulai pelan.');
                }
                _ensureMessagingToken();
                final dayState = _deriveDayState(snapshot, role);
                final robotMood = _robotMood(dayState, snapshot, role);
                return Column(
                  children: [
                    _topBar(greeting: greeting),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                _totalCard(snapshot, dayState),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: ConfettiWidget(
                                    confettiController: _confetti,
                                    blastDirectionality:
                                        BlastDirectionality.explosive,
                                    shouldLoop: false,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _robotSection(robotMood, dayState),
                            const SizedBox(height: 12),
                            IndividualTracker(snapshot: snapshot),
                            const SizedBox(height: 12),
                            AdvancedTracker(snapshot: snapshot, role: role),
                            const SizedBox(height: 12),
                            _eventCard(role, dayState, snapshot),
                            const SizedBox(height: 12),
                            _quickActions(),
                            if (statusCopy.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(statusCopy, textAlign: TextAlign.center),
                            ],
                          ],
                        ),
                      ),
                    ),
                    _bottomNav(),
                  ],
                );
              },
              error: (e, st) => _failsafe('Kita lagi keblokir sebentar.'),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _failsafe(String message) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Offline-first',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Future<void> _ensureMessagingToken() async {
    if (_tokenSaved) return;
    final roomId = ref.read(gateProvider).roomId;
    final role = ref.read(gateProvider).role;
    if (roomId == null || role == null) return;
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await ref
          .read(realtimeRepositoryProvider)
          .roomsRef
          .child('$roomId/tokens/${role.displayName}')
          .set(token);
      setState(() => _tokenSaved = true);
    }
  }

  Widget _topBar({required String greeting}) {
    final role = ref.read(gateProvider).role ?? Role.ibra;
    final avatarAsset =
        role == Role.ibra ? 'assets/pf_ibra.png' : 'assets/pf_sinta.png';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage(avatarAsset), radius: 26),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const Text(
                'Target: iPhone',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
    );
  }

  Widget _totalCard(RoomSnapshot snapshot, DayState dayState) {
    final role = ref.read(gateProvider).role ?? Role.ibra;
    final total = snapshot.members.values.map((e) => e.totalSaved).sum;
    final todayTotal = snapshot.todayTotal(DateTime.now());
    final target = snapshot.meta.targetAmount;
    final progress =
        target == 0 ? 0.0 : (total / target).clamp(0, 1).toDouble();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Total berdua',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => hideAmount = !hideAmount),
                icon: Icon(
                  hideAmount ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ],
          ),
          Text(
            hideAmount ? '••••' : 'Rp ${total.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 6),
          Text(
            'Hari ini: Rp ${hideAmount ? '•••' : todayTotal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 4),
          Text(
            dayState == DayState.deposited
                ? 'Hari ini aman. ${role.partnerName} bakal senyum.'
                : 'Masih ada ruang buat setoran kecil.',
          ),
        ],
      ),
    );
  }

  Widget _robotSection(RobotMood mood, DayState state) {
    String caption;
    switch (mood) {
      case RobotMood.happy:
        caption = 'Robot lagi senyum. Ritme kalian kerasa.';
        break;
      case RobotMood.waiting:
        caption = 'Robot lagi nungguin gerak kecil hari ini.';
        break;
      case RobotMood.disappointed:
        caption = 'Pelan aja. Besok coba lagi.';
        break;
      case RobotMood.proud:
        caption = 'Robot bangga. Streak kalian kerasa.';
        break;
      default:
        caption = 'Robot standby, nemenin kalian.';
    }
    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mood: ${mood.name}'),
                const SizedBox(height: 4),
                Text(caption),
                const SizedBox(height: 8),
                Text('State hari ini: ${state.name}'),
              ],
            ),
          ),
          Expanded(
            child: Lottie.asset(
              'assets/robot_3d.json',
              height: 140,
              repeat: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 14,
            runSpacing: 14,
            children: [
              QuickActionButton(
                label: '+7K',
                icon: Icons.bolt,
                onTap: () => _depositQuick(7000),
              ),
              QuickActionButton(
                label: 'Custom',
                icon: Icons.edit,
                onTap: () => _depositQuick(12000),
              ),
              QuickActionButton(
                label: 'History',
                icon: Icons.history,
                onTap: () {},
              ),
              QuickActionButton(
                label: 'Room info',
                icon: Icons.link,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Bareng dibuat cuma untuk kalian berdua.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _eventCard(Role role, DayState dayState, RoomSnapshot snapshot) {
    final engine = EventCopyEngine();
    final streak = calculateStreak(snapshot.dailySavings, role);
    final daily = engine.daily(role, dayState);
    final weekly = engine.weekly(role, streak);
    final missed = engine.missed(role);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            daily.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(daily.body),
          const SizedBox(height: 8),
          Text(
            weekly.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(weekly.body),
          const SizedBox(height: 8),
          Text(missed.title, style: const TextStyle(color: Colors.amber)),
          Text(missed.body),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return NavigationBar(
      backgroundColor: Colors.black.withAlpha(77),
      indicatorColor: Colors.white12,
      selectedIndex: 2,
      onDestinationSelected: (index) {},
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.list_alt), label: 'History'),
        NavigationDestination(
          icon: Icon(Icons.add_circle, size: 36),
          label: 'Add',
        ),
        NavigationDestination(icon: Icon(Icons.alarm), label: 'Alarm'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  DayState _deriveDayState(RoomSnapshot snapshot, Role role) {
    final todayKey = formatDateKey(DateTime.now());
    final daily = snapshot.dailySavings[todayKey] ?? {};
    if ((daily[role.displayName] ?? 0) > 0) return DayState.deposited;
    if (daily.isEmpty) return DayState.opened;
    if (daily.values.every((value) => value <= 0)) return DayState.opened;
    final lastKey = snapshot.dailySavings.keys.toList()..sort();
    final latest = lastKey.isNotEmpty ? lastKey.last : todayKey;
    final latestDate = DateTime.parse(latest);
    if (latestDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return DayState.missed;
    }
    return DayState.opened;
  }

  RobotMood _robotMood(DayState state, RoomSnapshot snapshot, Role role) {
    switch (state) {
      case DayState.deposited:
        return RobotMood.happy;
      case DayState.missed:
        return RobotMood
            .disappointed; // TODO: replace robot animation for mood: proud
      case DayState.opened:
        return RobotMood.waiting;
      case DayState.idle:
        return RobotMood.neutral;
    }
  }
}
