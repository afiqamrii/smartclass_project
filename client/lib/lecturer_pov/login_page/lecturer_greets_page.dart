import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartclass_fyp_2024/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/login_page/lecturer_signin.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/login_page/lecturer_signup_page.dart';
import 'package:smartclass_fyp_2024/widget/appbar.dart';

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
            //Login button (use CustomButton component)
            CustomButton(
              text: "Login",
              onTap: () {
                Navigator.push(
                  context,
                  _createRoute(
                    LecturerLoginPage(), //Direct to Login page
                  ),
                );
              },
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
                    _createRoute(
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
