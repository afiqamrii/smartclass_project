import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smartclass_fyp_2024/features/student/class_session/student_myclass.dart';
import 'package:smartclass_fyp_2024/features/student/student_homepage.dart';
import 'package:smartclass_fyp_2024/features/student/manage_profile/student_profilepage.dart';

class StudentBottomNavbar extends StatefulWidget {
  final int initialIndex;

  const StudentBottomNavbar({super.key, required this.initialIndex});

  @override
  State<StudentBottomNavbar> createState() => _StudentBottomNavbarState();
}

class _StudentBottomNavbarState extends State<StudentBottomNavbar> {
  late int _currentIndex;
  final List<Widget> _screens = [
    const StudentHomePage(),
    const StudentMyclass(),
    const StudentProfilepage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white.withOpacity(0.15)),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 7),
          child: GNav(
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            color: Colors.black,
            activeColor: Colors.purple, // selected icon and text color
            tabBackgroundColor:
                Colors.purple.withOpacity(0.1), // selected tab background color
            padding: const EdgeInsets.all(11),
            gap: 6,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.class_,
                text: 'My Class',
              ),
              GButton(
                icon: Icons.person,
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/pictures/compPicture.jpg'), //Later letak gambar disini from database / gambar user
                  radius: 15,
                ),
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
