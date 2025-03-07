import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/login/lecturer_login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCB9DF0),
      body: Stack(
        children: [
          // Blur Black Gradient Overlay at the Bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // Stick to the bottom
            child: Container(
              height: MediaQuery.sizeOf(context).height *
                  0.3, // 30% of screen height
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            // Allows scrolling if content is too long
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical:
                    MediaQuery.sizeOf(context).height * 0.2, // Reduce padding
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Let's Getting\nStarted",
                    style: TextStyle(
                      fontSize: 39,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 40), // Reduce excessive spacing
                  LottieBuilder.asset(
                    "assets/animations/animation_welcome.json",
                    width: 380,
                    fit: BoxFit.contain,
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
                        color: Colors.white,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 192, 28, 113),
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LecturerLoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Let's Begin",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 100), // Add some spacing before the gradient
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
