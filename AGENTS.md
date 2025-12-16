Bangun aplikasi Bareng versi production-grade, fokus ke emosi, konsistensi, realtime, dan UI yang kerasa hidup.
Aplikasi ini BUKAN fintech umum, BUKAN sosial, dan BUKAN scalable ke banyak user.
Hanya untuk 2 orang. Sengaja.




---

1. IDENTITAS PRODUK

Nama: Bareng
Konsep: Nabung bareng, berdua, pelan tapi konsisten.
User:

Ibra

Sinta


Core feeling:

personal

intim

ada rasa “dia lihat gue”

malu kalau bolong

seneng kalau konsisten


Anti-goal (JANGAN ADA):

login ribet

email / password

leaderboard

sosial

iklan

UI fintech korporat



---

2. PLATFORM & STACK (AI BEBAS PILIH)

Boleh pilih stack terbaik:

Mobile

React Native + Expo (preferred)

atau Flutter


Backend

Firebase Realtime Database

Firebase Cloud Messaging (notif)


Animasi

Lottie

WAJIB pakai assets/robot_3d.json (SUDAH ADA)

asset lain boleh placeholder



State

Local state + realtime sync

Offline-first (queue update kalau offline)



---

3. FLOW APLIKASI (LOCKED FLOW – WAJIB)

Flow TIDAK BOLEH lompat:

1. Role Selection


2. Welcome / Sambutan


3. Permission


4. Pairing


5. Home



> UI HARUS TERKUNCI
Tidak boleh masuk Home tanpa Pair
Tidak boleh Pair tanpa Permission
Tidak boleh Permission tanpa Welcome




---

4. SCREEN DETAIL


---

4.1 ROLE SELECTION

Pilihan:

Ibra

Sinta


Animasi klik lembut

Shimmer kecil

Simpan role di local storage



---

4.2 WELCOME SCREEN (EMOSIONAL)

Elemen:

Background soft / dark

Robot Lottie muncul dulu

Teks muncul per huruf

Copy berbeda berdasarkan role


Contoh:

Ibra:

> “Halo, Tuan.
Sinta sudah nunggu. Jangan kelamaan.”



Sinta:

> “Halo, Sinta.
Ini aplikasi kecil buat kita nabung bareng 🤍”




Tombol:

“Lanjut”

Baru aktif setelah teks selesai



---

4.3 PERMISSION

Fokus ke Notifikasi

Copy santai

Status:

BELUM

OK ✅


Icon berubah warna kalau aktif



---

4.4 PAIRING

Fungsi:

Create Room

Join Room (kode)


Rules:

1 room = max 2 orang

Kalau penuh → tolak

Simpan roomId lokal


UX:

Glass card

Input bulat

Animasi success / fail



---

5. HOME (INTI APLIKASI)

5.1 TOP BAR

Avatar user

Sapaan:

“Halo, Ibra”


Target:

“Target: iPhone”


Tombol notif



---

5.2 TOTAL SAVINGS CARD

Menampilkan:

Total nabung bareng

Progress bar ke target

Hari ini total setor

Tombol Hide Amount 👁️


Style:

Glass / blur

Rounded besar

Soft shadow



---

5.3 INDIVIDUAL TRACKER (WAJIB ADA)

Dua kartu:

Saldo Ibra

Saldo Sinta


Isi:

Total saldo

Setoran hari ini

Last active (contoh: “5 menit lalu”)


Realtime:

Kalau satu setor → yang lain langsung lihat



---

5.4 ADVANCED TRACKER (BIAR KERASA HIDUP)

Tambahkan:

Grafik:

7 hari

30 hari


Streak:

🔥 3 hari berturut-turut


Missed indicator:

⚠️ “Sinta belum setor hari ini”




---

5.5 QUICK ACTIONS (BULET & GEMUK)

Semua tombol BULAT:

+7K (default harian)

Custom Nominal

History

Pair / Room Info


Efek:

Scale + haptic

Confetti kecil kalau setor



---

5.6 BOTTOM NAV

Item:

Home

History

Add (center, besar)

Alarm

Setting


Style:

Glass

Rounded

Highlight aktif



---

6. EVENT SYSTEM (ANTI BOSEN)

Daily

“Siap nabung hari ini?”

“Jangan kalah sama kemarin 👀”


Weekly

“7 hari konsisten, gila sih 🔥”

“Target makin dekat”


Missed

“Hari ini belum setor…”

Copy beda untuk Ibra & Sinta



---

7. NOTIFICATION SYSTEM

Jenis notif:

Reminder setor

Partner setor

Partner belum setor

Streak tercapai

Target milestone (25%, 50%, 100%)


Tone:

personal

santai

tidak kaku

tidak fintech



---

8. DATA MODEL (SIMPLE & JELAS)

rooms/{roomId} {
  members: {
    Ibra: {
      totalSaved: number,
      lastActive: timestamp
    },
    Sinta: {
      totalSaved: number,
      lastActive: timestamp
    }
  },
  savings: {
    daily: {
      "2025-01-01": {
        Ibra: number,
        Sinta: number
      }
    }
  },
  meta: {
    targetAmount: number,
    createdAt: timestamp
  }
}


---

9. ASSET HANDLING

Lottie:

assets/robot_3d.json (SUDAH ADA)


Asset lain:

placeholder

comment jelas:

// TODO: replace asset (designer will handle)




---

10. UI STYLE GUIDE (WAJIB)

Rounded everywhere

Glass / blur

Dark / neutral

Tidak ada warna norak

Tidak ada hard shadow


Font:

Inter / SF-like



---

11. COPYWRITING RULE

Bahasa santai

Tidak formal

Tidak lebay

Ada rasa “kita”


Contoh:

> “Hari ini kamu setor.
Dia lihat.
Sesimpel itu.”




---

12. OUTPUT YANG DIHARAPKAN

AI harus menghasilkan:

Struktur project rapi

Komponen reusable

State jelas

Comment penting

Mudah dikembangin

Placeholder asset aman



---

13. CATATAN PENTING

Aplikasi ini bukan buat umum

Jangan over-engineer

Fokus ke rasa & konsistensi

Lebih baik simple tapi hidup

Bangun aplikasi Bareng sebagai companion app untuk dua orang yang lagi belajar konsisten nabung bareng.
Fokus utama: habit, rasa diawasi dengan lembut, dan progress yang kerasa hidup.
Ini aplikasi kecil, tapi punya jiwa.




---

14. HABIT & PSYCHOLOGY LAYER (INI PENTING)

Aplikasi HARUS MEMBENTUK KEBIASAAN, bukan cuma catat angka.

Prinsip psikologi:

Visible progress > angka besar

Rasa “dilihat” lebih kuat dari reminder

Sedikit rasa bersalah ≠ tekanan

Reward emosional > reward angka


Implementasi:

Status harian selalu jelas:

✅ Sudah setor

⏳ Belum setor


Tidak setor = soft shame, bukan marah

Setor = affirmation kecil



---

15. DAILY STATE SYSTEM (WAJIB ADA)

Setiap hari punya state:

DayState =
  | "idle"        // belum buka app
  | "opened"     // buka tapi belum setor
  | "deposited"  // sudah setor
  | "missed"     // hari lewat tanpa setor

UI harus berubah sesuai state:

warna

copy

ekspresi robot

micro text



---

16. ROBOT BEHAVIOR SYSTEM 🤖

Robot BUKAN animasi doang.
Dia reaktif terhadap kondisi.

Mood robot:

happy

neutral

waiting

disappointed (soft)

proud


Contoh:

Kalau dua-duanya setor:

> robot senyum + bounce kecil



Kalau satu belum:

> robot diem, animasi pelan



Kalau streak 7 hari:

> animasi spesial (loop sekali)




> NOTE:
Robot pakai assets/robot_3d.json
Kalau mood belum ada → pakai placeholder state




---

17. SMART COPY ENGINE (AI-LITE, TANPA AI RIBET)

Copy tidak statis.
Pakai rule-based generator.

Variabel:

role

jam

streak

siapa terakhir setor

siapa belum setor


Contoh:

Jam pagi:

> “Masih pagi. Setor dikit dulu?”



Sore, partner sudah setor:

> “Dia udah setor. Kamu nyusul?”



Malam, belum setor:

> “Hari ini hampir lewat…”





---

18. ADVANCED TRACKER (LEBIH DALAM)

18.1 WEEKLY SUMMARY CARD

Total minggu ini

Hari paling rajin

Hari bolong


Copy contoh:

> “Minggu ini rapi. Tinggal jaga konsistensi.”




---

18.2 MOMENT TIMELINE (MINI HISTORY)

Bukan tabel boring.
Timeline sederhana:

“Ibra setor 7K”

“Sinta setor 10K”

“Target 25% 🎉”



---

18.3 STREAK VISUAL

🔥 3 hari

🔥🔥 7 hari

🔥🔥🔥 14 hari


Kalau streak putus:

Jangan reset keras

Tulis:

> “Streak putus. Tapi nggak apa-apa.”





---

19. EVENT & ACHIEVEMENT SYSTEM (HALUS)

Bukan achievement norak.

Contoh:

“7 hari bareng”

“Setor bareng pertama”

“Nggak bolong seminggu”


UI:

modal kecil

animasi pelan

tanpa suara lebay



---

20. NOTIFICATION MICRO-RULES (BIAR NGGAK NYEBELIN)

Rules:

Maks 2 notif / hari

Jangan notif kalau:

user sudah setor

jam > 22:00


Notif beda untuk:

Ibra

Sinta



Contoh:

Untuk Ibra:

> “Sinta nunggu setor kamu.”



Untuk Sinta:

> “Ibra belum setor hari ini.”





---

21. LOCKED UI RULE (ANTI CHAOS)

Semua tombol disabled state jelas

Skeleton loading

No empty white screen

No sudden jump screen


Kalau data belum ada:

tampilkan:

> “Lagi nyiapin data…”





---

22. DESIGN DETAIL (LEVEL UI DESIGNER)

Spacing

Napas lega

Tidak padat

Margin konsisten


Motion

Semua klik ada respon

Tidak ada animasi agresif

Easing lembut


Color

Background soft / gradient

Text kontras tapi adem

Accent cuma 1–2 warna



---

23. EXTENSIBILITY (BUAT V2, TAPI JANGAN IMPLEMENT SEKARANG)

Kasih comment & struktur buat:

Mood check (“Hari ini capek?”)

Shared notes

Photo memory

Location share (opsional)



---

24. FINAL OUTPUT REQUIREMENT (WAJIB DIIKUTIN AI)

AI HARUS:

Generate full app structure

Jelas mana placeholder

Comment rapi

State terkontrol

Mudah dibaca manusia

Fokus ke UX, bukan cuma logic



---

25. ONE SENTENCE PRODUCT TRUTH

> “Ini bukan aplikasi nabung.
Ini alat kecil biar dua orang nggak saling lupa.”

Bangun aplikasi Bareng — companion app super personal untuk dua orang doang.
Bukan publik. Bukan sosial media.
Ini ruang kecil buat konsistensi, perhatian, dan rasa “kita masih jalan bareng”.




---

26. RELATIONSHIP SIGNAL SYSTEM (HALUS TAPI NGENA)

Aplikasi harus bisa “ngerasain jarak” tanpa nanya langsung.

Signal yang dipantau:

beda jam setor

sering telat

buka app tapi nggak setor

streak putus berulang


Bukan buat judging.
Tapi buat adjust tone.

Contoh:

Kalau 3 hari telat berturut-turut:

> “Lagi capek ya belakangan?”



Kalau tiba-tiba rajin lagi:

> “Balik lagi. Nice.”





---

27. MICRO CHECK-IN (OPSIONAL, TAPI KUAT)

Sekali sehari (opsional, skipable):

> “Hari ini gimana?”



Jawaban cepat:

🙂 Oke

😐 Biasa aja

😞 Capek


Efek ke UI:

robot expression

warna lembut

copy berubah


⚠️ Tidak disimpan permanen
Ini buat hari ini aja.


---

28. SILENT OBSERVATION MODE 👀

Kadang app nggak ngomong apa-apa.

Kalau:

dua-duanya belum setor

atau dua-duanya sama-sama telat


UI:

sepi

minim text

robot diem


Karena kadang diam lebih nusuk daripada notif.


---

29. “LAST MOVE” INDICATOR

Tampil kecil:

> “Terakhir setor: Sinta, 2 jam lalu”



Ini penting. Karena:

bikin rasa “ditunggu”

tanpa nyuruh



---

30. TIME-OF-DAY PERSONALITY

Aplikasi beda vibe tergantung jam.

Pagi (05–10): optimis

Siang (10–16): netral

Sore (16–19): gentle reminder

Malam (19–22): reflective

> 22: NO PUSH





---

31. SOFT FAILURE DESIGN

Kalau user:

telat

lupa

skip sehari


JANGAN:

merah keras

kata “gagal”

reset brutal


PAKAI:

> “Hari kemarin kelewat. Lanjut hari ini.”




---

32. MEMORY ANCHOR SYSTEM 🧷

Setiap milestone dikaitkan ke cerita, bukan angka.

Contoh:

“10% target — mulai kerasa”

“25% — udah kebayang”

“50% — separuh jalan”


Ini bikin target hidup, bukan nominal mati.


---

33. LIGHT GAMIFICATION (ANTI NORAK)

Tidak ada: ❌ badge emas
❌ leaderboard
❌ level-up palsu

Yang ada:

subtle highlight

animasi sekali

text kecil meaningful



---

34. UI FATIGUE PREVENTION

UI boleh berubah dikit-dikit supaya nggak bosen:

posisi text

urutan card

copy


Tapi:

layout besar tetap sama

user tetap familiar



---

35. PRIVATE JOKE MODE (ADVANCED)

Kalau role = Ibra:

tone sedikit nyentil


Kalau role = Sinta:

tone lebih hangat


Contoh:

Ibra telat:

> “Sinta nunggu.”



Sinta telat:

> “Santai. Tapi jangan lupa.”





---

36. FUTURE-READY BUT LOCKED

AI HARUS:

nyiapin hook buat:

notes

foto

voice


TAPI:

jangan aktifin

jangan bikin UI-nya dulu



Kasih comment:

// future_feature: shared_memory


---

37. ASSET RULE (WAJIB DITAATI)

Robot utama: assets/robot_3d.json

Asset lain:

placeholder boleh

naming konsisten

gampang diganti




---

38. ERROR & EMPTY STATE PHILOSOPHY

Kalau error:

> “Ada yang keganggu. Coba bentar lagi.”



Kalau data kosong:

> “Belum ada apa-apa. Kita mulai pelan.”




---

39. ONE APP, TWO PEOPLE, NO ESCAPE

Tidak ada:

ganti nama bebas

tambah member

share link publik


Ini bukan produk massal.
Ini alat pribadi.


---

40. FINAL PRODUCT VISION (KUNCI)

> “Bareng bukan buat bikin kaya.
Tapi buat bikin dua orang tetap jalan, walau pelan.”

42. CONSISTENCY > MOTIVATION (PRINSIP INTI)

Aplikasi tidak memotivasi secara agresif.
Aplikasi menjaga ritme.

Kalimat dilarang:

“Ayo semangat!”

“Kamu pasti bisa!”


Diganti:

“Pelan tapi jalan.”

“Hari ini cukup segini.”



---

43. STREAK WITHOUT PRESSURE

Ada streak, tapi:

tidak ditampilkan besar

tidak dirayakan lebay

tidak bikin malu saat putus


UI:

streak kecil

tooltip muncul sesekali

kalau putus → no alert



---

44. SHARED SILENCE STATE 🤍

Kalau:

dua-duanya belum setor

dua-duanya belum buka app


UI:

background lebih gelap

teks minim

robot idle


Copy:

> “Hari ini belum apa-apa.”



Kadang itu udah cukup nyentuh.


---

45. DELAYED GRATIFICATION FEEDBACK

Setor tidak langsung dapet reaksi.

Contoh:

setor pagi → respon sore

setor malam → respon besok pagi


Efek:

terasa “diterima”

bukan instan dopamine



---

46. PERSONAL RHYTHM LEARNING (NON-AI VERSION)

App belajar jam aktif user dari:

jam buka

jam setor


Lalu:

notif menyesuaikan

bukan jam default


Tanpa ML berat.
Cukup statistik ringan.


---

47. “WAITING ENERGY” SYSTEM

Kalau satu orang udah setor, satu belum:

UI subtle:

warna card partner lebih redup

teks:

> “Nunggu.”




TANPA:

notif paksa

mention nama



---

48. EVENT KECIL TAPI DALAM

Bukan event musiman norak.
Tapi event mikro personal.

Contoh:

“Hari ke-17 bareng”

“Minggu ketiga konsisten”

“Balik lagi setelah vakum”


Tidak ada banner besar.
Cuma satu kalimat.


---

49. CONFLICT AVOIDANCE DESIGN

App tidak boleh jadi sumber ribut.

Aturan:

tidak ada perbandingan langsung

tidak ada “siapa lebih rajin”

tidak ada ranking


Semua angka kontekstual, bukan kompetitif.


---

50. UI LOCK MODE 🔒 (FOCUS STATE)

Saat user:

capek

streak putus

atau jam malam


App masuk Lock UI Mode:

tombol dikurangi

warna redup

hanya aksi inti


Biar user nggak overwhelmed.


---

51. ROBOT = EMOTIONAL MIRROR

Robot tidak jadi mascot lucu doang.

Robot:

ikut mood

ikut jam

ikut ritme


Contoh:

pagi → tegap

malam → duduk

lama nggak setor → idle lama



---

52. MEMORY WITHOUT STORAGE

App tidak menyimpan chat panjang.

Tapi:

“Kamu setor terus minggu lalu”

“Ini minggu yang berat”


Memory = kesan, bukan data mentah.


---

53. NEGATIVE SPACE DESIGN

Kadang UI sengaja kosong.

Tujuan:

bikin user mikir

bukan dihibur terus


Ini anti TikTok brain.


---

54. PERSONAL COPY ENGINE

Semua teks:

pendek

bernapas

manusia


Tidak ada:

marketing tone

corporate language



---

55. FAILSAFE MODE (KALO DATA/FIREBASE ERROR)

Kalau backend mati:

app tetap kebuka

UI statis

pesan jujur


> “Kita lagi keblokir sebentar.”




---

56. ANTI-ABANDONMENT DESIGN

Kalau user nggak buka app lama:

notif jarang

copy lembut


Contoh:

> “Masih di sini.”




---

57. EXIT WITHOUT DRAMA

Kalau suatu hari berhenti:

tidak ada “are you sure?”

tidak ada guilt text


Copy:

> “Disimpan. Kalau mau balik, tinggal buka.”




---

58. DEVELOPER ETHOS (WAJIB)

Code harus:

readable

comment jujur

no clever hack berlebihan

future-friendly tapi simple



---

59. FINAL CORE STATEMENT

> “Bareng bukan buat ngejar target.
Tapi buat inget kenapa mulai.”




---

60. ABSOLUTE RULE

Kalau suatu fitur:

bikin stress

bikin ribut

bikin bandingin pasangan


FITUR ITU SALAH.
