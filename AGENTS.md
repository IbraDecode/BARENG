Kamu adalah Senior Flutter Engineer + UI Engineer + UX Writer. Target: bikin aplikasi Bareng yang kerasa hidup, fokus ke emosi + konsistensi + realtime.

Aplikasi ini Bukan fintech, bukan sosial, bukan scalable. Cuma untuk 2 orang: Ibra dan Sinta. Sengaja.

Kalau kamu bikin “versi demo/minimal”, kamu gagal.


---

0) HARD RULES (GA BOLEH DILANGGAR)

❌ Tidak ada login / email / password / auth flow.

❌ Tidak ada leaderboard / ranking / banding-bandingin.

❌ Tidak ada iklan.

❌ Tidak ada UI fintech corporate.

✅ Offline-first: kalau offline, aksi disimpan ke queue lalu sync saat online.

✅ Realtime: kalau satu setor, yang lain langsung lihat.

✅ LOCKED FLOW wajib (tidak boleh lompat screen).



---

1) PLATFORM & STACK (FIXED)

Flutter

Flutter stable (pakai versi stable terbaru yang kompatibel)

Dart 3+

Android-first (tapi project tetap Flutter standar)


Firebase

Firebase Realtime Database

Firebase Cloud Messaging (FCM) untuk notif

Pakai FlutterFire (firebase_core, firebase_database, firebase_messaging)


Animasi

Lottie wajib

WAJIB pakai file ini:

assets/robot_3d.json


Background image:

assets/bg_apple.jpg


Asset lain boleh placeholder, tapi harus ada TODO comment jelas.


Storage lokal

shared_preferences untuk role + flags + roomId

hive atau isar buat offline queue (pilih salah satu, jelasin kenapa, implement beneran)


State management

Pilih salah satu: Riverpod (preferred) atau Bloc

Tapi harus rapih, scalable untuk project kecil (2 user) tanpa over-engineer.



---

2) INPUT KONFIG FIREBASE (PAKAI INI)

Gunakan data ini untuk setup FlutterFire (Android):

packageName: bareng.apps

realtime db url: https://bareng-b9d88-default-rtdb.asia-southeast1.firebasedatabase.app

projectId: bareng-b9d88


Konfigurasi sumber:

{
  "project_info": {
    "project_number": "405330435328",
    "firebase_url": "https://bareng-b9d88-default-rtdb.asia-southeast1.firebasedatabase.app",
    "project_id": "bareng-b9d88",
    "storage_bucket": "bareng-b9d88.firebasestorage.app"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:405330435328:android:e542998a6a4149c91fe7e5",
        "android_client_info": {
          "package_name": "bareng.apps"
        }
      },
      "api_key": [
        { "current_key": "AIzaSyA5pcyHyPlrSRaX90n4dxGtkX52NFYge6E" }
      ]
    }
  ]
}

Aturan

AI wajib buat instruksi setup Firebase Android yang bener:

generate android/app/google-services.json (atau minta user paste file itu ke path tersebut)

update Gradle plugin sesuai FlutterFire

flutterfire configure bisa dipakai kalau tersedia, tapi jangan asumsi user punya akses CLI; kasih alternatif manual.




---

3) FLOW APLIKASI (LOCKED FLOW — WAJIB)

Flow TIDAK BOLEH lompat:

1. Role Selection


2. Welcome / Sambutan


3. Permission (notif)


4. Pairing


5. Home



LOCK RULES:

Tidak boleh masuk Home tanpa Pair

Tidak boleh Pair tanpa Permission

Tidak boleh Permission tanpa Welcome


Implement:

AppGate / RouterGuard yang cek local flags:

role

welcome_done

permission_done

roomId


Kalau tidak valid -> redirect otomatis.



---

4) DATA MODEL (SIMPLE & JELAS)

Gunakan model ini persis:

rooms/{roomId} {
  members: {
    Ibra: { totalSaved: number, lastActive: timestamp },
    Sinta: { totalSaved: number, lastActive: timestamp }
  },
  savings: {
    daily: {
      "YYYY-MM-DD": { Ibra: number, Sinta: number }
    }
  },
  meta: { targetAmount: number, createdAt: timestamp }
}

Wajib ada helper:

format date key YYYY-MM-DD

compute:

total berdua

today total

today per user

streak

weekly summary

last move indicator




---

5) SCREEN DETAIL (WAJIB ADA SEMUA)

5.1 ROLE SELECTION

2 tombol: Ibra / Sinta

animasi click lembut + shimmer kecil

simpan role ke local storage

UI dark glass + rounded


5.2 WELCOME (EMOSIONAL)

background assets/bg_apple.jpg (dark overlay)

robot lottie muncul dulu, baru text typewriter

copy beda untuk role:


Ibra:

> “Halo, Tuan.
Sinta udah nunggu. Jangan kelamaan.”



Sinta:

> “Halo, Sinta.
Ini aplikasi kecil buat kita nabung bareng 🤍”



tombol “Lanjut” baru aktif setelah teks selesai


5.3 PERMISSION (Notif)

fokus permission notif Android 13+

status:

“BELUM”

“OK ✅”


icon berubah warna

copy santai


5.4 PAIRING

Fungsi:

Create Room

Join Room pakai kode


Rules:

1 room max 2 orang

kalau penuh -> tolak

simpan roomId lokal


UX:

glass card

input bulat

animasi success / fail

ada “room info” yang jelas


5.5 HOME (INTI)

Wajib ada:

Topbar

avatar

sapaan “Halo, Ibra”

target “Target: iPhone”

tombol notif


Total card

total berdua

progress bar

hari ini total

tombol hide 👁️


Individual tracker (WAJIB)

card Ibra & Sinta

total saldo, hari ini, last active


Advanced tracker

chart 7 hari & 30 hari (pakai fl_chart)

streak kecil

missed indicator:

“⚠️ Sinta belum setor hari ini”



Quick Actions (BULAT & GEMUK)

+7K

Custom nominal

History

Pair / room info


Efek:

scale

haptic

confetti (pakai package confetti / custom)


Bottom nav

Home

History

Add (center besar)

Alarm

Settings Glass style + highlight active



---

6) EVENT SYSTEM (ANTI BOSEN)

Bikin event generator harian/mingguan:

Daily nudges (halus)

Weekly: “7 hari konsisten, gila sih 🔥”

Missed: “Hari ini belum setor…”


Copy harus beda untuk Ibra vs Sinta (tone private joke mode).


---

7) ROBOT BEHAVIOR SYSTEM 🤖 (WAJIB ADA)

Robot bukan animasi doang. Robot mood:

happy

neutral

waiting

disappointed (soft)

proud


Robot berubah berdasar:

dayState

siapa sudah setor

siapa belum

streak

jam


Kalau mood asset belum ada:

tetap implement logic + fallback ke robot_3d.json

kasih TODO comment: // TODO: replace robot animation for mood: proud



---

8) DAILY STATE SYSTEM (WAJIB)

DayState:

idle (belum buka)

opened (buka tapi belum setor)

deposited (udah setor)

missed (hari lewat tanpa setor)


UI home harus berubah sesuai state:

copy

accent halus

robot behavior



---

9) NOTIFICATION SYSTEM (WAJIB)

Notif types:

Reminder setor

Partner setor

Partner belum setor

Streak tercapai

Milestone 25/50/100%


Micro rules:

max 2 notif/hari

jangan notif kalau user udah setor

jam > 22:00 -> no push

tone personal, ga kaku, ga fintech


Implementasi:

Local scheduling (flutter_local_notifications) + remote FCM

Untuk production: remote notif idealnya dari server, tapi karena project ini “2 user”, kamu boleh:

fallback local notif rules

dan simpan token FCM di RTDB untuk partner notification trigger (minimal viable remote)




---

10) UI STYLE GUIDE (WAJIB)

rounded everywhere

glassmorphism / blur

dark / neutral gradient

soft shadow

spacing lega

motion lembut (curves easeOut, durasi pendek)

jangan warna norak



---

11) OUTPUT YANG HARUS KAMU HASILKAN (AI WAJIB)

Kamu harus commit full project dengan:

Struktur folder rapi

Komponen reusable

State management jelas

Services:

firebase init

realtime db repo

notification service

offline queue


Screens lengkap sesuai flow

Placeholder assets aman

Comments penting

Build instructions jelas:


Wajib ada dokumen:

README.md (cara run, build apk)

AGENTS.md (cara agent bekerja + aturan)

TESTING.md (cara test fitur utama)

ARCHITECTURE.md (overview singkat)


Wajib ada minimal test:

unit test untuk:

date key formatter

streak calculator

copy engine rules


widget test minimal untuk:

flow locked redirect




---

12) BUILD & CI (WAJIB)

Buat GitHub Actions:

flutter analyze

flutter test

build:

flutter build apk --release


upload artifact APK


Kalau kamu gak bisa push langsung:

buat branch + pull request



---

13) FAILSAFE MODE

Kalau Firebase error:

app tetap kebuka

UI statis + pesan jujur:

> “Kita lagi keblokir sebentar.”




Kalau data kosong:

“Belum ada apa-apa. Kita mulai pelan.”


No blank white screen. No sudden jump.


---

14) FINAL TRUTH

> “Ini bukan aplikasi nabung.
Ini alat kecil biar dua orang nggak saling lupa.”



ABSOLUTE RULE: Kalau fitur bikin stress / bikin ribut / bikin bandingin pasangan → fitur itu salah.


---

15) START TASK (LANGKAH EKSEKUSI WAJIB)

1. Buat project Flutter baru dengan package: bareng.apps


2. Setup assets (bg + robot)


3. Setup Firebase + RTDB + messaging


4. Implement locked flow (AppGate)


5. Implement Pairing (create/join + max 2 member)


6. Implement Home realtime + trackers + quick actions


7. Implement notifications rules


8. Add offline queue + sync replay


9. Add tests + CI


10. Update docs + commit
