import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/role.dart';
import '../../services/local_flags.dart';
import '../../providers.dart';

final gateProvider = StateNotifierProvider<AppGateNotifier, LocalFlagState>((
  ref,
) {
  final repo = ref.watch(localFlagsRepositoryProvider);
  return AppGateNotifier(repo);
});

class AppGateNotifier extends StateNotifier<LocalFlagState> {
  AppGateNotifier(this._repo, {LocalFlagState? seed})
    : super(seed ?? LocalFlagState.initial()) {
    if (seed == null) {
      _hydrate();
    }
  }

  final LocalFlagsRepository _repo;

  Future<void> _hydrate() async {
    final loaded = await _repo.load();
    state = loaded.copyWith(initialized: true);
  }

  Future<void> selectRole(Role role) async {
    await _repo.setRole(role);
    state = state.copyWith(role: role, initialized: true);
  }

  Future<void> completeWelcome() async {
    await _repo.markWelcome();
    state = state.copyWith(welcomeDone: true, initialized: true);
  }

  Future<void> completePermission() async {
    await _repo.markPermission();
    state = state.copyWith(permissionDone: true, initialized: true);
  }

  Future<void> setRoom(String roomId) async {
    await _repo.saveRoomId(roomId);
    state = state.copyWith(roomId: roomId, initialized: true);
  }

  /// Returns the next mandatory route based on the current gate state.
  ///
  /// This is shared by redirects and active screens that need to move forward
  /// once a flag (e.g. permission) flips.
  String get requiredRoute => _requiredRoute;

  String? redirectFor(String location) {
    final requiredRoute = _requiredRoute;
    if (!state.initialized) {
      if (location == '/loading') return null;
      return '/loading';
    }
    if (location == requiredRoute) return null;
    // Do not allow forward navigation beyond required route
    if (requiredRoute == '/home') {
      return null;
    }
    return requiredRoute;
  }

  String get _requiredRoute {
    if (state.role == null) return '/role';
    if (!state.welcomeDone) return '/welcome';
    if (!state.permissionDone) return '/permission';
    if (!state.paired) return '/pair';
    return '/home';
  }
}
