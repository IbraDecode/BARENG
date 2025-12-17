import 'package:shared_preferences/shared_preferences.dart';
import '../models/role.dart';

class LocalFlagState {
  const LocalFlagState({
    required this.role,
    required this.welcomeDone,
    required this.permissionDone,
    required this.roomId,
    required this.initialized,
  });

  final Role? role;
  final bool welcomeDone;
  final bool permissionDone;
  final String? roomId;
  final bool initialized;

  bool get paired => roomId != null && roomId!.isNotEmpty;

  LocalFlagState copyWith({
    Role? role,
    bool? welcomeDone,
    bool? permissionDone,
    String? roomId,
    bool? initialized,
  }) {
    return LocalFlagState(
      role: role ?? this.role,
      welcomeDone: welcomeDone ?? this.welcomeDone,
      permissionDone: permissionDone ?? this.permissionDone,
      roomId: roomId ?? this.roomId,
      initialized: initialized ?? this.initialized,
    );
  }

  static LocalFlagState initial() => const LocalFlagState(
        role: null,
        welcomeDone: false,
        permissionDone: false,
        roomId: null,
        initialized: false,
      );
}

class LocalFlagsRepository {
  LocalFlagsRepository(this._prefs);
  final SharedPreferences _prefs;

  static const _roleKey = 'role';
  static const _welcomeKey = 'welcome_done';
  static const _permissionKey = 'permission_done';
  static const _roomIdKey = 'room_id';

  Future<LocalFlagState> load() async {
    final roleStr = _prefs.getString(_roleKey);
    return LocalFlagState(
      role: _toRole(roleStr),
      welcomeDone: _prefs.getBool(_welcomeKey) ?? false,
      permissionDone: _prefs.getBool(_permissionKey) ?? false,
      roomId: _prefs.getString(_roomIdKey),
      initialized: true,
    );
  }

  Future<void> setRole(Role role) async {
    await _prefs.setString(_roleKey, role.name);
  }

  Future<void> markWelcome() async => _prefs.setBool(_welcomeKey, true);
  Future<void> markPermission() async => _prefs.setBool(_permissionKey, true);
  Future<void> saveRoomId(String roomId) async => _prefs.setString(_roomIdKey, roomId);
  Future<void> clearRoom() async => _prefs.remove(_roomIdKey);

  Role? _toRole(String? value) {
    if (value == null) return null;
    return Role.values.firstWhere(
      (element) => element.name == value,
      orElse: () => Role.ibra,
    );
  }
}
