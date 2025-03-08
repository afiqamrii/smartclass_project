import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/login/lecturer_login_page.dart';

class Intropage2 extends StatelessWidget {
  const Intropage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: LottieBuilder.asset(
              "assets/animations/introPage2.json",
              width: 290,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40), // Adjust spacing
          const Center(
            child: Text(
              "AI-Powered Lecture Summarization",
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
              "Never miss an important lecture point! Our AI-powered transcription and summarization ensure you have clear and concise lecture notes in real time.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Figtree',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // const SizedBox(height: 40),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Center(
          //     child: SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.5,
          //       child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: const Color.fromARGB(255, 192, 28, 113),
          //         ),
          //         onPressed: () async {
          //           Navigator.push(
          //             context,
          //             _createRoute(),
          //           );
          //         },
          //         child: const Text(
          //           "Let's Begin",
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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
