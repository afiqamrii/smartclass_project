import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Intropage3 extends StatelessWidget {
  const Intropage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: LottieBuilder.asset(
              "assets/animations/introPage3.json",
              frameRate: FrameRate.max,
              width: 250,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40), // Adjust spacing
          const Center(
            child: Text(
              "Smart Attendance Tracking",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Figtree',
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.0),
            child: Text(
              "No more manual roll calls! Our automated attendance system uses RFID and sensors to track attendance effortlessly.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Figtree',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
