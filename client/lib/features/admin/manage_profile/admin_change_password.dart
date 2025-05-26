import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/shared/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/role.dart';

import '../../../../shared/data/services/auth_services.dart';

class AdminChangePassword extends ConsumerWidget {
  AdminChangePassword({super.key});

  //Import AuthServices
  final authService = AuthService();

  //Text editing controller
  final emailController = TextEditingController();

  //Sign user in method
  void requestPasswordReset(
      BuildContext context, WidgetRef ref, String userEmail) async {
    ref.read(loadingProvider.notifier).state = true; //Start loading

    await authService.requestPasswordReset(
      context: context,
      userEmail: userEmail,
      isChangePassword: true,
      roleId: Role.staff,
    );

    ref.read(loadingProvider.notifier).state = false; //Stop loading after done
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    double screenWidth = MediaQuery.of(context).size.width;

    //Get user data from provider
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Change Password",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.15),
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
                  "Change Password?",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'FigtreeExtraBold',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "No worries, we got you covered. We'll send you instructions to change the password to ${user.userEmail}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            //Login button
            CustomButton(
              text: 'Send Request',
              isLoading: ref.watch(loadingProvider), //Pass the loading state
              onTap: () {
                requestPasswordReset(context, ref, user.userEmail);
              },
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
