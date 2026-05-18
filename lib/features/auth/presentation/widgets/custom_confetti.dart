import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CustomConfetti extends StatelessWidget {
  final ConfettiController controller; // 🎮 रिमोट कंट्रोल

  const CustomConfetti({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: controller,
      blastDirectionality: BlastDirectionality.explosive, // 🎉 चारों तरफ धमाका होगा
      shouldLoop: false,
      maxBlastForce: 20, // पटाखों की स्पीड
      minBlastForce: 8,
      emissionFrequency: 0.05,
      numberOfParticles: 30, // कितने टुकड़े गिरेंगे
      colors: const [
        Colors.greenAccent,
        Colors.blueAccent,
        Colors.pinkAccent,
        Color(0xFF00E5FF),
        Colors.purpleAccent
      ], // हमारे ऐप के नियॉन थीम कलर्स
    );
  }
}