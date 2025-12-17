# TESTING

## Prasyarat
- Flutter SDK sudah ada di PATH (`/workspace/flutter/bin`).
- Dependencies sudah diunduh (`flutter pub get`).

## Perintah utama
- Unit & widget test: `flutter test`
  - Meliputi: formatter tanggal (`date_utils_test.dart`), kalkulasi streak, engine copy event, dan widget test guard flow (`app_gate_widget_test.dart`).
- Static analysis: `flutter analyze`

## Catatan
- Test widget guard memakai `SharedPreferences.setMockInitialValues` agar tidak menyentuh device storage.
- Jika ingin menambah test UI lain, gunakan komponen glass/rounded yang sudah ada supaya konsisten.
