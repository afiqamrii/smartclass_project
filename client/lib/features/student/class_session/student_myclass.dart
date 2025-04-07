import 'package:flutter/material.dart';

class StudentMyclass extends StatelessWidget {
  const StudentMyclass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Class"),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text("My Class Page"),
      ),
      // bottomNavigationBar: const LectBottomNavBar(initialIndex: 1),
    );
  }
}
