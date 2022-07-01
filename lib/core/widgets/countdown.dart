import 'dart:ui';

import 'package:flutter/material.dart';

class Countdown extends AnimatedWidget {
  final Animation<int> animation;
  const Countdown({
    super.key,
    required super.listenable,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Text(
      timerText,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        color: Theme.of(context).primaryColor,
        fontFeatures: const [
          FontFeature.tabularFigures(),
        ],
      ),
    );
  }
}
