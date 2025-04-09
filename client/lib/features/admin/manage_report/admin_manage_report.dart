import 'package:flutter/material.dart';

class AdminManageReport extends StatelessWidget {
  const AdminManageReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Report"),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text("My Report Page"),
      ),
      // bottomNavigationBar: const LectBottomNavBar(initialIndex: 1),
    );
  }
}
