import 'package:bareng/src/models/day_state.dart';
import 'package:bareng/src/models/event_prompt.dart';
import 'package:bareng/src/models/role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('daily copy adapts per role and state', () {
    final engine = EventCopyEngine();
    final ibraCopy = engine.daily(Role.ibra, DayState.idle);
    expect(ibraCopy.title.contains('Tuan'), true);

    final sintaCopy = engine.daily(Role.sinta, DayState.missed);
    expect(sintaCopy.body.toLowerCase().contains('besok'), true);
  });

  test('weekly copy celebrates streak', () {
    final engine = EventCopyEngine();
    final prompt = engine.weekly(Role.ibra, 7);
    expect(prompt.title.contains('🔥'), true);
  });
}
