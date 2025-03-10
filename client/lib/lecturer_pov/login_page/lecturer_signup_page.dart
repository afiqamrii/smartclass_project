import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/widget/appbar.dart';

class LecturerSignupPage extends StatelessWidget {
  const LecturerSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Appbar(),
      body: Center(
        child: Text('Lecturer Signup Page'),
      ),
    );
  }
}
