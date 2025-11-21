import 'dart:async';
import 'package:flutter/services.dart';

class IdleService {
  static Timer? _timer;
  static const Duration timeout = Duration(minutes: 5);

  /// Llamar cada vez que el usuario interactúa
  static void resetTimer(Function onTimeout) {
    _timer?.cancel();
    _timer = Timer(timeout, () {
      onTimeout();
    });
  }

  /// Cancelar manualmente si lo necesitas
  static void cancel() {
    _timer?.cancel();
  }
}
