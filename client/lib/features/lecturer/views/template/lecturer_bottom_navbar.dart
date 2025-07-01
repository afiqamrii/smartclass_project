import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/lecturer_homepage.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_profile/lecturer_profile_page.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class LectBottomNavBar extends ConsumerStatefulWidget {
  final int initialIndex;

  const LectBottomNavBar({super.key, required this.initialIndex});

  @override
  ConsumerState<LectBottomNavBar> createState() => _LectBottomNavBarState();
}

class _LectBottomNavBarState extends ConsumerState<LectBottomNavBar> {
  late int _currentIndex;
  final List<Widget> _screens = [
    const LectHomepage(),
    const LecturerProfilePage(),
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
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 7),
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
