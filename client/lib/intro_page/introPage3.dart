import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartclass_fyp_2024/login/lecturer_login_page.dart';

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
              width: 290,
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

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const LecturerLoginPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
