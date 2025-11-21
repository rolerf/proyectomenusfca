import 'package:flutter/material.dart';
import 'idle_service.dart';

class IdleWrapper extends StatelessWidget {
  final Widget child;
  final Function onTimeout;

  const IdleWrapper({super.key, required this.child, required this.onTimeout});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => IdleService.resetTimer(onTimeout),
      child: child,
    );
  }
}
