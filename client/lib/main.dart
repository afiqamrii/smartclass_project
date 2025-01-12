import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/template/lecturer_bottom_navbar.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartClass FYP',
      theme: ThemeData(
        fontFamily: 'Figtree',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
          const MainScreen(), // Navigate to the MainScreen with navigation functionality
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final int _currentIndex = 0;
  // final List<Widget> _screens = [
  //   LectHomepage(), // Lecturer homepage
  //   const LecturerMyclass(), // MyClass screen
  //   const LecturerProfilePage(), // Lecturer profile page
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LectBottomNavBar(initialIndex: _currentIndex),
    );
  }
}
