import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartclass_fyp_2024/admin_pov/staff_signin.dart';
import 'package:smartclass_fyp_2024/admin_pov/staff_signup.dart';
import 'package:smartclass_fyp_2024/widget/appbar.dart';
import 'package:smartclass_fyp_2024/widget/pageTransition.dart';

class AdminGreetsPage extends StatelessWidget {
  const AdminGreetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(), //Appbar widget
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Column(
            children: [
              //Picture of lecturer ilustration
              SvgPicture.asset(
                'assets/icons/admin.svg',
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              const SizedBox(height: 20),
              //Greetings
              const Text(
                "Hi, Admin!",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'FigtreeExtraBold',
                  fontWeight: FontWeight.bold,
                ),
              ),
              //Description
              const SizedBox(height: 20),
              const Text(
                "Welcome to IntelliClass, the smart classroom management system. Login to manage your classroom utilities and devices.",
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
                        PPHStaffLoginPage(),
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
                        StaffSignUpPage(),
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
      ),
    );
  }
}
