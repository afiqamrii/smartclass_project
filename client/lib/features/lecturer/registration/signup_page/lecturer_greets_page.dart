import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartclass_fyp_2024/core/widget/pageTransition.dart';
import 'package:smartclass_fyp_2024/features/lecturer/registration/signin_page/lecturer_signin.dart';
import 'package:smartclass_fyp_2024/features/lecturer/registration/signup_page/lecturer_signup_page.dart';
import 'package:smartclass_fyp_2024/core/widget/appbar.dart';
import 'package:smartclass_fyp_2024/features/onboarding/login_as.dart';

class LecturerGreetsPage extends StatelessWidget {
  const LecturerGreetsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const Appbar(),
      body: _greetsSection(context),
    );
  }

  Padding _greetsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Center(
        child: Column(
          children: [
            //Picture of lecturer ilustration
            SvgPicture.asset(
              'assets/icons/lecturer.svg',
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            const SizedBox(height: 20),
            //Greetings
            const Text(
              "Hi, Lecturer!",
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'FigtreeExtraBold',
                fontWeight: FontWeight.bold,
              ),
            ),
            //Description
            const SizedBox(height: 20),
            const Text(
              "Welcome to IntelliClass, where you can easily manage your classroom experience.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Figtree',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            //Login button
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 192, 28, 113),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    upTransition(
                      LecturerLoginPage(),
                    ),
                  );
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            //Sign Up button
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                      color: Color.fromARGB(255, 192, 28, 113)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    toLeftTransition(
                      LecturerSignupPage(), //Direct to Sign Up page
                    ),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Color.fromARGB(255, 192, 28, 113),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            if (!Navigator.canPop(context))
              //Back to choose role button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Choose another role?",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontFamily: 'Figtree',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        toRightTransition(
                          const LoginAsPage(), //Direct to choose role page
                        ),
                      );
                    },
                    child: const Text(
                      "Click here",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 192, 28, 113),
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leadingWidth: 100,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
              Text(
                "Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
