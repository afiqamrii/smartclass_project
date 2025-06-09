import 'package:flutter/material.dart';

class AcademicAdminDeleteClassroom extends StatefulWidget {
  const AcademicAdminDeleteClassroom({super.key});

  @override
  State<AcademicAdminDeleteClassroom> createState() =>
      _AcademicAdminDeleteClassroomState();
}

class _AcademicAdminDeleteClassroomState
    extends State<AcademicAdminDeleteClassroom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Classroom"),
        // automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text("Delete Classroom Page"),
      ),
    );
  }
}
