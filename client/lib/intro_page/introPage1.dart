import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Intropage1 extends StatelessWidget {
  const Intropage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: LottieBuilder.asset(
              "assets/animations/welcomepage.json",
              width: 290,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40), // Adjust spacing
          const Center(
            child: Text(
              "Welcome to IntelliClass",
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
              "IntelliClass automates your classroom experience. From managing utilities to generating lecture notes, we’ve got it all covered!",
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