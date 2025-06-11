import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smartclass_fyp_2024/features/super_admin/homepage/super_admin_homepage.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_profile/views/super_admin_profile_page.dart';

class SuperadminBottomNav extends StatefulWidget {
  final int initialIndex;

  const SuperadminBottomNav({super.key, required this.initialIndex});

  @override
  State<SuperadminBottomNav> createState() => _SuperadminBottomNavState();
}

class _SuperadminBottomNavState extends State<SuperadminBottomNav> {
  late int _currentIndex;
  final List<Widget> _screens = [
    const SuperAdminHomepage(),
    const SuperAdminProfilePage(),
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
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 7),
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
