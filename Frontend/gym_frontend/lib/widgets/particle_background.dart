// lib/widgets/particle_background.dart
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';

class ParticleBackground extends StatefulWidget {
  final Widget child;
  const ParticleBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bool dark = brightness == Brightness.dark;

    // Layer A: soft drifting dust
    final dust = ParticleOptions(
      baseColor: dark ? Colors.blueGrey.shade300 : Colors.grey.shade500,
      spawnMinRadius: 1.0,
      spawnMaxRadius: 3.0,
      spawnMinSpeed: 2.0,
      spawnMaxSpeed: 8.0,
      spawnOpacity: dark ? 0.25 : 0.3,
      minOpacity: 0.05,
      maxOpacity: 0.4,
      opacityChangeRate: 0.05,
      particleCount: dark ? 25 : 20,
    );

    // Layer B: faint warm sparks
    final sparks = ParticleOptions(
      baseColor: dark ? Colors.deepOrange.shade200 : Colors.orange.shade400,
      spawnMinRadius: 2.0,
      spawnMaxRadius: 5.0,
      spawnMinSpeed: 5.0,
      spawnMaxSpeed: 15.0,
      spawnOpacity: 0.5,
      minOpacity: 0.1,
      maxOpacity: 0.6,
      opacityChangeRate: 0.15,
      particleCount: dark ? 10 : 8,
    );

    // Stack: dust, sparks, faint lines
    return Stack(
      children: [
        AnimatedBackground(
          vsync: this,
          behaviour: RandomParticleBehaviour(options: dust),
          child: const SizedBox.expand(),
        ),
        AnimatedBackground(
          vsync: this,
          behaviour: RandomParticleBehaviour(options: sparks),
          child: const SizedBox.expand(),
        ),
        AnimatedBackground(
          vsync: this,
          behaviour: RacingLinesBehaviour(
            direction: LineDirection.Ltr,
            numLines: 3, // fewer, calmer
          ),
          child: widget.child,
        ),
      ],
    );
  }
}
