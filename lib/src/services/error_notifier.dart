import 'package:flutter/foundation.dart';

class ErrorNotifier extends ChangeNotifier {
  final List<String> _errors = [];

  List<String> get errors => List.unmodifiable(_errors);

  void recordError(Object error, StackTrace? stackTrace) {
    final message = '[${DateTime.now().toIso8601String()}] $error';
    _errors.add(message);
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
    notifyListeners();
  }

  void clear() {
    _errors.clear();
    notifyListeners();
  }
}
