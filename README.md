# Bareng (buat Ibra & Sinta aja)

> Ini bukan aplikasi nabung. Ini alat kecil biar dua orang nggak saling lupa.

## Gambaran
- Flow terkunci: Role → Welcome emosional → Permission → Pairing → Home.
- Offline-first + realtime: aksi disimpan ke Hive queue saat offline, disinkron ke Firebase Realtime Database saat online.
- Notif lembut: Flutter Local Notifications + FCM (max 2 notif/hari, no fintech tone).
- Visual: glassmorphism, rounded, background `assets/bg_apple.jpg`, robot Lottie `assets/robot_3d.json`.

## Setup cepat
1. Pastikan Flutter (stable) ada di PATH: `export PATH=/workspace/flutter/bin:$PATH`.
2. Install dependencies: `flutter pub get`.
3. Firebase (Android):
   - Pastikan `android/app/google-services.json` terisi (sudah disediakan dari brief). Jika hilang, isi dengan konfigurasi:
     - package_name: `bareng.apps`
     - apiKey: `AIzaSyA5pcyHyPlrSRaX90n4dxGtkX52NFYge6E`
     - appId: `1:405330435328:android:e542998a6a4149c91fe7e5`
     - projectId: `bareng-b9d88`
     - databaseURL: `https://bareng-b9d88-default-rtdb.asia-southeast1.firebasedatabase.app`
   - Plugin `com.google.gms.google-services` sudah diaktifkan di `android/app/build.gradle.kts` & `android/settings.gradle.kts`.
4. Jalankan: `flutter run` (Android-first). Jika emulator minta izin notif, pilih izinkan.

## Struktur penting
- `lib/main.dart` → bootstrap (Firebase, Hive queue, notifikasi) + ProviderScope override.
- `lib/src/features/gate` → AppGate (router guard) + flow lock.
- `lib/src/features/role|welcome|permission|pairing|home` → screen berurutan.
- `lib/src/services` → realtime repo, offline queue (Hive), notif, local flags.
- `lib/src/utils/date_utils.dart` → formatter `YYYY-MM-DD`, streak, indikator gerakan.
- `lib/src/models/event_prompt.dart` → copy engine untuk event harian/mingguan/missed.

## Build
- Debug run: `flutter run`.
- Release APK: `flutter build apk --release` (lihat CI workflow `.github/workflows/flutter.yml`).

## Bundle
- Arsip zip siap pakai: `bareng.zip` di root repo (tidak termasuk `.git`).
- Regenerasi bila perlu: `zip -r bareng.zip . -x "bareng.zip" -x ".git/*"`.

## Prinsip produk
- Tidak ada login/leaderboard/iklan.
- Dua orang aja, tidak untuk publik.
- Tone human, tidak menggurui, tidak bikin bersalah.

## Offline & failsafe
- Setoran gagal → masuk antrean Hive (`pending_actions`), disinkron ulang saat konek.
- Firebase down → UI tetap muncul dengan pesan jujur: “Kita lagi keblokir sebentar.”

## TODO next
- Animasi khusus per `RobotMood` (gantikan fallback `robot_3d.json`).
- History & alarm tab yang lebih kaya + sinkronisasi partner push token di RTDB.
