import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartclass_fyp_2024/features/onboarding/splashscreen/welcomePage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset(
              "assets/animations/animation1.json",
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
      nextScreen: const WelcomePage(),
      splashIconSize: 200,
      duration: 6000,
    );
  }
}
