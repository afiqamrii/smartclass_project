import 'package:flutter/material.dart';

class LecturerProfilePage extends StatelessWidget {
  const LecturerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: const Center(
        child: Text("Profile Page"),
      ),
      // bottomNavigationBar: const LectBottomNavBar(initialIndex: 2),
    );
  }
}
