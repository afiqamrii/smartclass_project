import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/splashscreen/welcomePage.dart';

class LecturerLoginPage extends StatelessWidget {
  const LecturerLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page Her"),
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomePage(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                ],
              ),
            )),
      ),
      body: const Center(
        child: Text(
          "Login Page",
        ),
      ),
    );
  }
}
