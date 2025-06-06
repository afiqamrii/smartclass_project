import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/shared/components/confirmPassword_textfield.dart';
import 'package:smartclass_fyp_2024/shared/components/login_textfield.dart';
import 'package:smartclass_fyp_2024/shared/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/shared/components/password_textfield.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/role.dart';
import 'package:smartclass_fyp_2024/shared/widgets/appbar.dart';

import '../../../../../shared/data/services/auth_services.dart';

class LecturerSignupPage extends ConsumerWidget {
  LecturerSignupPage({super.key});

  //Import AuthServices
  final authService = AuthService();

  //Text editing controller
  final userNameController = TextEditingController();
  final name = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final lecturerIdController = TextEditingController();

  //Sign user in method
  void signUserIn(BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).state = true; //Start loading

    await authService.signUpUser(
      context: context,
      ref: ref,
      userName: userNameController.text,
      name: name.text,
      userEmail: emailController.text,
      userPassword: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      roleId: Role.lecturer, //Set roleId to 2 (Lecturer)
      externalId: lecturerIdController.text, //Set externalId to username
    );

    ref.read(loadingProvider.notifier).state = false; //Stop loading after done
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const Appbar(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.01,
              right: screenWidth * 0.01,
              bottom: screenWidth * 0.15,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Hey, Lecturer. \nLet's sign you in.",
                        style: TextStyle(
                          fontSize: 27,
                          fontFamily: 'FigtreeExtraBold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                //Username textfield
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                //Username textfield
                MyLoginTextField(
                  controller: userNameController,
                  hintText: 'alibinabu123',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                //Name textfield
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                //Name textfield
                MyLoginTextField(
                  controller: name,
                  hintText: 'Ahmad Ali',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                //Lecturer id textfield
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Lecturer ID',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                //Lecturer id textfield
                MyLoginTextField(
                  controller: lecturerIdController,
                  hintText: 'L1234',
                  obscureText: false,
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
                  hintText: 'alibinabu@gmail.com',
                  obscureText: false,
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
                  isPasswordForm: true,
                  isSignUpForm: true,
                  hintText: 'Password',
                  obscureText: true,
                  password: passwordController.text,
                ),

                const SizedBox(height: 20),

                //Confirm Password title
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                //Confirm password textfield
                ConfirmPasswordTextfield(
                  controller: confirmPasswordController,
                  passwordController: passwordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                //Login button
                CustomButton(
                  text: 'Create Account',
                  isLoading:
                      ref.watch(loadingProvider), //Pass the loading state
                  onTap: () {
                    signUserIn(context, ref);
                  },
                ),
              ],
            ),
          ),
        ],
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
