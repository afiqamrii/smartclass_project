import 'package:flutter/material.dart';

class AcademicAdminAddclass extends StatefulWidget {
  const AcademicAdminAddclass({super.key});

  @override
  State<AcademicAdminAddclass> createState() => _AcademicAdminAddclassState();
}

class _AcademicAdminAddclassState extends State<AcademicAdminAddclass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Classroom"),
        // automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text("Add Classroom Page"),
      ),
    );
  }
}
