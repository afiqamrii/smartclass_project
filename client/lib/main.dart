import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/master/app_strings.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/services/auth_services.dart';
import 'package:smartclass_fyp_2024/features/onboarding/splashscreen/splashScreen.dart';
import 'package:smartclass_fyp_2024/navigator_validToken.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStrings.loadStrings();
  // await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool isLoading = true;
  bool tokenExpired = false; // Track token expiry

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = await ref.read(authServiceProvider).getUserData();

    // Check if user data is null or token is invalid
    if (user != null) {
      ref.read(userProvider.notifier).setUserFromModel(user);
    } else {
      setState(() {
        tokenExpired = true; // Mark token as expired
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Show SnackBar if token expired
    if (tokenExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Token expired. Please log in again."),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }

    return Scaffold(
      body: user.token.isNotEmpty
          ? NavigatorValidToken.navigateAfterLogin(
              context, user.roleId) // Direct to page based on roleId
          : const SplashScreen(), // Show SplashScreen if token is empty
    );
  }
}
