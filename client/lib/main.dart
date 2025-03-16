import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_homepage.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/template/lecturer_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/services/lecturer/auth_services.dart';
import 'package:smartclass_fyp_2024/splashscreen/splashScreen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the AuthService provider

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IntelliClass',
      theme: ThemeData(
        fontFamily: 'Figtree',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

final authServiceProvider = Provider((ref) => AuthService());

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // Create a boolean variable to track the loading state
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    await ref.read(authServiceProvider).getUserData(ref);
    setState(() {
      isLoading = false; // Stop the loading animation
    });
  }

  @override
  Widget build(BuildContext context) {
    // get data from provider
    final user = ref.watch(userProvider);

    if (isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Scaffold(
      body: user.token.isNotEmpty
          ? const LectBottomNavBar(
              initialIndex: 0) // Show Lecturer Homepage if token is present
          : const SplashScreen(), // Show SplashScreen if token is not present
    );
  }
}
