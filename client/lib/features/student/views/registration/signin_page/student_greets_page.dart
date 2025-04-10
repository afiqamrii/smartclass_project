import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartclass_fyp_2024/features/onboarding/login_as.dart';
import 'package:smartclass_fyp_2024/features/student/views/registration/signin_page/student_signin.dart';
import 'package:smartclass_fyp_2024/features/student/views/registration/signup_page/student_signup.dart';
import 'package:smartclass_fyp_2024/shared/widgets/appbar.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class StudentGreetsPage extends StatelessWidget {
  const StudentGreetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: _greetStudentSection(context),
    );
  }

  Padding _greetStudentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Center(
        child: Column(
          children: [
            //Picture of lecturer ilustration
            SvgPicture.asset(
              'assets/icons/student.svg',
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            const SizedBox(height: 20),
            //Greetings
            const Text(
              "Hi, Student!",
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'FigtreeExtraBold',
                fontWeight: FontWeight.bold,
              ),
            ),
            //Description
            const SizedBox(height: 20),
            const Text(
              "Welcome to IntelliClass, the smart classroom management system that helps you to learn better and smarter.",
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
                      StudentLoginPage(),
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
                      StudentSignupPage(),
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
}
