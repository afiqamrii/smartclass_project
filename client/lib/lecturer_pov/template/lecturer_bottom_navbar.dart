import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_homepage.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_myclass.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_profile_page.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'My Class',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
