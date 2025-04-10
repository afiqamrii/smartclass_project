import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/lecturer_homepage.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_myclass.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_profile/lecturer_profile_page.dart';

class LectBottomNavBar extends StatefulWidget {
  final int initialIndex;

  const LectBottomNavBar({super.key, required this.initialIndex});

  @override
  State<LectBottomNavBar> createState() => _LectBottomNavBarState();
}

class _LectBottomNavBarState extends State<LectBottomNavBar> {
  late int _currentIndex;
  final List<Widget> _screens = [
    LectHomepage(),
    const LecturerMyclass(),
    const LecturerProfilePage(),
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
