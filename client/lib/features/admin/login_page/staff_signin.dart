import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/core/components/login_textfield.dart';
import 'package:smartclass_fyp_2024/core/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/core/components/password_textfield.dart';
import 'package:smartclass_fyp_2024/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/registration/signin_page/resetPassword_page.dart';
import 'package:smartclass_fyp_2024/core/widget/appbar.dart';
import 'package:smartclass_fyp_2024/core/widget/pageTransition.dart';

import '../../../data/services/auth_services.dart';

class PPHStaffLoginPage extends ConsumerStatefulWidget {
  PPHStaffLoginPage({super.key});

  @override
  _PPHStaffLoginPageState createState() => _PPHStaffLoginPageState();
}

class _PPHStaffLoginPageState extends ConsumerState<PPHStaffLoginPage> {
  //Import AuthServices
  final authService = AuthService();

  //Form key
  final _formKey = GlobalKey<FormState>();

  //Text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Sign user in method
  void signUserIn(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      ref.read(loadingProvider.notifier).state = true;

      bool isTimeout = false;

      // Timeout Future
      Future timeoutFuture = Future.delayed(const Duration(seconds: 30), () {
        if (mounted) {
          // <- Important!
          isTimeout = true;
          ref.read(loadingProvider.notifier).state = false;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request Timeout. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });

      // Login + Timeout Race
      await Future.any([
        authService.loginUser(
          context: context,
          ref: ref,
          userEmail: emailController.text,
          userPassword: passwordController.text,
        ),
        timeoutFuture,
      ]);

      // Stop loading if login completes first
      if (!isTimeout && mounted) {
        ref.read(loadingProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const Appbar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //Logo
              const Image(
                image: AssetImage('assets/pictures/logo.png'),
                height: 120,
                width: 150,
              ),
              const Text(
                'Log In As PPH Staff',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'FigtreeExtraBold',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              //Email title
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),

              //Email textfield
              MyLoginTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              //Password title
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),

              //Password textfield
              PasswordTextfield(
                controller: passwordController,
                hintText: 'Password',
                isPasswordForm: true,
                isSignUpForm: false,
                obscureText: true,
                password : passwordController.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              //Forgot password
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    toLeftTransition(
                      ResetPasswordPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //Login button
              CustomButton(
                text: 'Login',
                isLoading: ref.watch(loadingProvider),
                onTap: () {
                  signUserIn(context, ref);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leadingWidth: 100,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
              Text(
                "Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
