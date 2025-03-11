import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/components/login_textfield.dart';
import 'package:smartclass_fyp_2024/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/template/lecturer_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/widget/appbar.dart';

class LecturerLoginPage extends StatelessWidget {
  LecturerLoginPage({super.key});

  //Text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(

      ),
      body: Center(
        child: Column(
          children: [
            //Logo
            const Image(
              image: AssetImage('assets/pictures/logo.png'),
              height: 120,
              width: 150,
            ),
            const Text(
              'Log in',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'FigtreeExtraBold',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            //Email textfield
            MyLoginTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(height: 20),

            //Password textfield
            MyLoginTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 15),

            //Forgot password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //Login button
            CustomButton(
              text: 'Login',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LectBottomNavBar(initialIndex: 0),
                  ),
                );
              },
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
