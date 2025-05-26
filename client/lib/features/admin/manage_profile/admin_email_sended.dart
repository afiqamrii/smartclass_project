import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:smartclass_fyp_2024/features/admin/bottom_nav/admin_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/shared/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/role.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/data/services/auth_services.dart';

class AdminEmailSended extends ConsumerWidget {
  final String userEmail;

  AdminEmailSended(this.userEmail, {super.key});

  //Import AuthServices
  final authService = AuthService();

  //Sign user in method
  void requestPasswordReset(BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).state = true; //Start loading

    await authService.requestPasswordReset(
      context: context,
      userEmail: userEmail,
      isChangePassword: true,
      roleId: Role.staff,
    );

    ref.read(loadingProvider.notifier).state = false; //Stop loading after done
  }

  void openEmailApp(BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).state = true; //Start loading

    final Uri emailUri = Uri(
      scheme: 'mailto', // Opens email app
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      // Show snackbar to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No email app available on your device.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    ref.read(loadingProvider.notifier).state = false; //Stop loading after done
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;

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
            Navigator.push(
              context,
              toRightTransition(
                const AdminBottomNavbar(initialIndex: 2),
              ),
            );
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.1),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                //Icon
                LottieBuilder.asset(
                  "assets/animations/emailSended.json",
                  width: 90,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Check your email",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'FigtreeExtraBold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "We sent a password reset link to \n ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontFamily: 'Figtree',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: userEmail,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontFamily: 'Figtree',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                //Login button
                CustomButton(
                  text: 'Open Email App',
                  isLoading:
                      ref.watch(loadingProvider), //Pass the loading state
                  onTap: () {
                    openEmailApp(context, ref);
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't receive an email?",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () => requestPasswordReset(context, ref),
                      child: const Text(
                        "Click here to resend",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontFamily: 'Figtree',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
