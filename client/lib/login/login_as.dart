import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartclass_fyp_2024/admin_pov/admin_greets_page.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/login_page/lecturer_greets_page.dart';
import 'package:smartclass_fyp_2024/student_pov/student_greets_page.dart';
import 'package:smartclass_fyp_2024/widget/appbar.dart';

class LoginAsPage extends StatelessWidget {
  const LoginAsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(
        
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: _selectRoleSection(context),
      ),
    );
  }

  Column _selectRoleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Your Role",
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'FigtreeExtraBold',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20), // Give spacing between text and buttons
        //Card for lecturer
        _lecturerSection(context),
        const SizedBox(height: 20), // Give spacing between buttons
        //Card for student
        _studentSection(context),
        const SizedBox(height: 20), // Give spacing between buttons
        //Card for admin
        _adminSection(context),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leadingWidth: 100,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
              Text(
                "Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widgets for each role
  //Lecturer
  GestureDetector _lecturerSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _createRoute(const LecturerGreetsPage()),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.18,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 240, 255),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Colors.black.withOpacity(0.8),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 9,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/icons/lecturer.svg',
                height: 90,
                width: 150,
              ),
              const SizedBox(width: 20),
              const Text(
                "Lecturer",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF37474F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Student
  GestureDetector _studentSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _createRoute(
            const StudentGreetsPage(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.18,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 240, 255),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Colors.black.withOpacity(0.8),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/icons/student.svg',
                height: 90,
                width: 150,
              ),
              const SizedBox(width: 20),
              const Text(
                "Student",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF37474F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Admin
  GestureDetector _adminSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _createRoute(
            const AdminGreetsPage(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.18,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 240, 255),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Colors.black.withOpacity(0.8),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/icons/admin.svg',
                height: 90,
                width: 150,
              ),
              const SizedBox(width: 20),
              const Text(
                "PPH Staff",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF37474F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Transition animation
Route _createRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
