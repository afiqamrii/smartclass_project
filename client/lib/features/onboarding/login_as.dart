import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/registration/signup_page/academic_admin_greets_page.dart';
import 'package:smartclass_fyp_2024/features/admin/registeration/signup_page/admin_greets_page.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/registration/signup_page/lecturer_greets_page.dart';
import 'package:smartclass_fyp_2024/features/student/views/registration/signin_page/student_greets_page.dart';
import 'package:smartclass_fyp_2024/features/super_admin/views/super_admin_signin.dart';
import 'package:smartclass_fyp_2024/shared/widgets/appbar.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class LoginAsPage extends StatelessWidget {
  const LoginAsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Select Your Role",
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'FigtreeExtraBold',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: RoleCard(
                        title: "Lecturer",
                        svgAsset: 'assets/icons/lecturer.svg',
                        onTap: () =>
                            _navigateTo(context, const LecturerGreetsPage()),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: RoleCard(
                        title: "Student",
                        svgAsset: 'assets/icons/student.svg',
                        onTap: () =>
                            _navigateTo(context, const StudentGreetsPage()),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: RoleCard(
                        title: "PPH Staff",
                        svgAsset: 'assets/icons/admin.svg',
                        onTap: () =>
                            _navigateTo(context, const AdminGreetsPage()),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: RoleCard(
                        title: "Academic Admin",
                        imageAsset: 'assets/pictures/admin-panel.png',
                        onTap: () => _navigateTo(
                            context, const AcademicAdminGreetsPage()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Are you a Super Admin?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  // Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        toLeftTransition(
                          SuperAdminSignin(),
                        ),
                      );
                    },
                    child: const Text(
                      "Click Here",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Figtree',
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, _createRoute(page));
  }

  Route _createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final String? svgAsset;
  final String? imageAsset;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    this.svgAsset,
    this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3E5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.8), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            if (svgAsset != null)
              SvgPicture.asset(
                svgAsset!,
                height: 80,
                width: 120,
              ),
            if (imageAsset != null)
              Image.asset(
                imageAsset!,
                height: 59,
                width: 80,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Figtree',
                fontWeight: FontWeight.w600,
                color: Color(0xFF37474F),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
