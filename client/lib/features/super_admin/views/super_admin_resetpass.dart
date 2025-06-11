import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/shared/components/login_textfield.dart';
import 'package:smartclass_fyp_2024/shared/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

import '../../../../../shared/data/services/auth_services.dart';

class SuperAdminResetpass extends ConsumerWidget {
  SuperAdminResetpass({super.key});

  //Import AuthServices
  final authService = AuthService();

  //Text editing controller
  final emailController = TextEditingController();

  //Sign user in method
  void requestPasswordReset(BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).state = true; //Start loading

    await authService.requestPasswordReset(
      context: context,
      userEmail: emailController.text,
      isChangePassword: false,
      roleId: ref.read(userProvider).roleId,
    );

    ref.read(loadingProvider.notifier).state = false; //Stop loading after done
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                //Icon
                const Image(
                  image: AssetImage('assets/icons/forgotPassword.png'),
                  height: 80,
                  width: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 27,
                        fontFamily: 'FigtreeExtraBold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "No worries, we got you covered. We'll send you reset instructions.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontFamily: 'Figtree',
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                //Username textfield
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
                  hintText: 'alibinabu123',
                  obscureText: false,
                ),

                const SizedBox(height: 30),

                //Login button
                CustomButton(
                  text: 'Reset Password',
                  isLoading:
                      ref.watch(loadingProvider), //Pass the loading state
                  onTap: () {
                    requestPasswordReset(context, ref);
                  },
                ),

                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Back to log in",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontFamily: 'Figtree',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
