import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CustomConfetti extends StatelessWidget {
  final ConfettiController controller; // 🎮 अब यही रहेगा असली रिमोट!

  const CustomConfetti({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: controller,
      blastDirectionality: BlastDirectionality.explosive, // 🎉 चारों तरफ धमाका
      shouldLoop: false,
      maxBlastForce: 20,
      minBlastForce: 8,
      emissionFrequency: 0.05,
      numberOfParticles: 35,
      colors: const [
        Colors.greenAccent,
        Colors.blueAccent,
        Colors.pinkAccent,
        Color(0xFF00E5FF),
        Colors.purpleAccent
      ],
    );
  }
}