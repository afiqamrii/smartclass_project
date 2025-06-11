import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/bottom_nav/academician_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/features/super_admin/bottom_navbar/superadmin_bottom_nav.dart';
import 'package:smartclass_fyp_2024/shared/data/models/role.dart';
import 'package:smartclass_fyp_2024/features/admin/bottom_nav/admin_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/features/student/views/template/student_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/template/lecturer_bottom_navbar.dart';

class NavigatorValidToken {
  static Widget navigateAfterLogin(BuildContext context, int roleId) {
    switch (roleId) {
      case Role.student:
        return const StudentBottomNavbar(initialIndex: 0);
      case Role.lecturer:
        return const LectBottomNavBar(initialIndex: 0);
      case Role.staff:
        return const AdminBottomNavbar(initialIndex: 0);
      case Role.academicStaff:
        return const AcademicianBottomNavbar(initialIndex: 0);
      case Role.superadmin:
        return const SuperadminBottomNav(initialIndex: 0);
      default:
        return const Scaffold(
          body: Center(child: Text("Invalid role")),
        );
    }
  }
}
