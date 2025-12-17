import '../models/role.dart';
import '../models/day_state.dart';

class EventPrompt {
  EventPrompt({required this.title, required this.body, required this.type});
  final String title;
  final String body;
  final String type;
}

class EventCopyEngine {
  EventPrompt daily(Role role, DayState state) {
    final prefix = role == Role.ibra ? 'Hei, Tuan' : 'Hei, Sinta';
    switch (state) {
      case DayState.idle:
        return EventPrompt(
          title: '$prefix, pelan aja.',
          body: 'Kita belum apa-apa hari ini. Mau buka bareng?',
          type: 'daily_idle',
        );
      case DayState.opened:
        return EventPrompt(
          title: '$prefix, ambil napas.',
          body: 'Kamu sudah buka aplikasi. Mau lanjut setor kecil? +7K juga oke.',
          type: 'daily_opened',
        );
      case DayState.deposited:
        return EventPrompt(
          title: '$prefix, nice.',
          body: 'Setoran hari ini aman. Mau ucapin terima kasih ke ${role.partnerName}?',
          type: 'daily_done',
        );
      case DayState.missed:
        return EventPrompt(
          title: 'Gak apa, hari ini lewat.',
          body: 'Besok kita mulai pelan lagi. Aku di sini kok.',
          type: 'daily_missed',
        );
    }
  }

  EventPrompt weekly(Role role, int streak) {
    final label = role == Role.ibra ? 'kalian berdua' : 'kalian';
    return EventPrompt(
      title: '7 hari konsisten, gila sih 🔥',
      body: 'Ritmenya kerasa lembut. $label berhasil jagain tempo.',
      type: 'weekly',
    );
  }

  EventPrompt missed(Role role) {
    final partner = role.partnerName;
    return EventPrompt(
      title: '$partner belum setor hari ini',
      body: 'Mau ingetin pelan-pelan? Kalau enggak juga gapapa.',
      type: 'missed',
    );
  }
}
