# Arsitektur Bareng (emosi dulu, teknis secukupnya)

## Lapisan utama
- **UI & Flow**: `lib/src/features/*` berurutan (role → welcome → permission → pairing → home). `AppGate` di `lib/src/features/gate/app_gate.dart` + `GoRouter` mencegah lompatan.
- **State management**: Riverpod (ProviderScope). Gate, room stream, dan service dibungkus provider di `lib/src/providers.dart`.
- **Services**:
  - Firebase init (`lib/firebase_options.dart`), Realtime DB repo (`lib/src/services/realtime_repository.dart`).
  - Offline queue dengan Hive (`lib/src/services/offline_queue_service.dart` + model `pending_action.dart`).
  - Notifikasi lokal + FCM (`lib/src/services/notification_service.dart`).
  - Local flags SharedPreferences (`lib/src/services/local_flags.dart`).
- **Theme & UI atoms**: glass + rounded di `lib/src/theme/app_theme.dart`, komponen `GlassCard`, `PrimaryButton`, `QuickActionButton`, `TypewriterText` di `lib/src/widgets`.

## Alur data kunci
1. **Bootstrap** (`lib/src/app_bootstrap.dart`): init Flutter binding, Firebase, Hive box `pending_actions`, notifikasi. ProviderScope dioverride dengan prefs/box/service dari bootstrap.
2. **Locked flow**: `AppGateNotifier` memutuskan redirect (role → welcome → permission → pair → home). Semua screen memanggil metode gate untuk menandai progres.
3. **Realtime**: `RealtimeRepository.watchRoom` memetakan RTDB ke `RoomSnapshot` (anggota, savings harian, meta). Home subscribe via `roomStreamProvider`.
4. **Offline-first**: setiap setoran panggil RTDB, jika gagal disimpan ke Hive queue. `syncIfOnline` akan replay saat koneksi ada.
5. **Event & robot**: copy generator (`EventCopyEngine`) + `DayState` + `RobotMood` mengubah tone dan teks di home (plus TODO untuk animasi mood khusus).

## Model & helper
- Model utama: `Role`, `DayState`, `RobotMood`, `RoomSnapshot`, `PendingAction`.
- Helper: formatter + streak di `lib/src/utils/date_utils.dart`, event copy di `lib/src/models/event_prompt.dart`.

## UI Screen
- `RoleScreen`: dua tombol glass + shimmer lembut.
- `WelcomeScreen`: bg `assets/bg_apple.jpg`, robot lottie, typewriter copy per role, tombol lanjut aktif setelah teks selesai.
- `PermissionScreen`: status BELUM/OK, permintaan notif Android 13+, copy santai.
- `PairingScreen`: create/join room, card glass, input bulat, animasi status.
- `HomeScreen`: topbar sapaan, total card + progress/hide, robot mood, tracker per user, advanced tracker (chart 7 hari, streak, missed indicator), quick actions bulat + confetti, event copy, bottom nav.

## Kenapa Hive?
Hive dipilih untuk offline queue karena ringan, tidak perlu generator kode besar, dan cukup untuk menyimpan antrean aksi kecil (setoran/pairing) yang harus disinkron ke RTDB.

## TODO strategis
- Tambah animasi spesifik per `RobotMood` (// TODO di home screen).
- Perluas notifikasi remote (simpan token FCM di RTDB, trigger partner push).
- Perhalus chart 30 hari & history detail di tab khusus.
