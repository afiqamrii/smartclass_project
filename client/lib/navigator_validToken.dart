import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/data/models/role.dart';
import 'package:smartclass_fyp_2024/features/student/template/student_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/features/lecturer/template/lecturer_bottom_navbar.dart';

class NavigatorValidToken {
  static Widget navigateAfterLogin(BuildContext context, int roleId) {
    switch (roleId) {
      case Role.student:
        return const StudentBottomNavbar(initialIndex: 0);
      case Role.lecturer:
        return const LectBottomNavBar(initialIndex: 0);
      case Role.staff:
        return const StudentBottomNavbar(initialIndex: 0);
      default:
        return const Scaffold(
          body: Center(child: Text("Invalid role")),
        );
    }
  }
}
