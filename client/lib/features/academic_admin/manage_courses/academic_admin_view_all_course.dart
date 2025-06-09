import 'package:flutter/material.dart';

class AcademicAdminViewAllCourse extends StatefulWidget {
  const AcademicAdminViewAllCourse({super.key});

  @override
  State<AcademicAdminViewAllCourse> createState() =>
      _AcademicAdminViewAllCourseState();
}

class _AcademicAdminViewAllCourseState
    extends State<AcademicAdminViewAllCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View All Courses"),
        // automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text("View All Courses Page"),
      ),
    );
  }
}
