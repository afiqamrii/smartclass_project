import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smartclass_fyp_2024/features/student/views/class_history/student_class_history.dart';
import 'package:smartclass_fyp_2024/features/student/views/student_homepage.dart';
import 'package:smartclass_fyp_2024/features/student/views/manage_profile/student_profilepage.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class StudentBottomNavbar extends ConsumerStatefulWidget {
  final int initialIndex;

  const StudentBottomNavbar({super.key, required this.initialIndex});

  @override
  ConsumerState<StudentBottomNavbar> createState() =>
      _StudentBottomNavbarState();
}

class _StudentBottomNavbarState extends ConsumerState<StudentBottomNavbar> {
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
    // Get user data
    final user = ref.watch(userProvider);

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
            tabs: [
              const GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              const GButton(
                icon: Icons.class_,
                text: 'My Class',
              ),
              GButton(
                icon: Icons.person,
                leading: CircleAvatar(
                  radius: 17,
                  backgroundImage: user.user_picture_url.isNotEmpty
                      ? NetworkImage(user.user_picture_url)
                      : const AssetImage(
                          'assets/pictures/compPicture.jpg',
                        ) as ImageProvider,
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
