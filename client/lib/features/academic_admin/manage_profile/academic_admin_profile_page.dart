import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_profile/academic_admin_account_details.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_profile/academic_admin_change_password.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/services/auth_services.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class AcademicAdminProfilePage extends ConsumerStatefulWidget {
  const AcademicAdminProfilePage({super.key});

  @override
  ConsumerState<AcademicAdminProfilePage> createState() => _AcademicAdminProfilePageState();
}

class _AcademicAdminProfilePageState extends ConsumerState<AcademicAdminProfilePage> {
  void signOutUser(BuildContext context) {
    AuthService().signOut(context, 4);
  }

  // ignore: unused_field
  bool _isRefreshing = false; // Add loading state

  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() {
      _isRefreshing = true;
    });

    await ref.read(userProvider.notifier).refreshUserData();

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Get user data
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.black87,
      body: LiquidPullToRefresh(
        onRefresh: () => _handleRefresh(ref),
        color: const Color(0xFF0d1116),
        springAnimationDurationInMilliseconds: 350,
        showChildOpacityTransition: false,
        child: ListView(physics: const BouncingScrollPhysics(), children: [
          // ignore: sized_box_for_whitespace
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 27,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          //Put picture profiles hereee
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                              'assets/pictures/compPicture.jpg',
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Name and email here
                              Text(
                                "Hi, ${user.userName} !",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Academic Admin",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Account Settings",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            // Profile Details
                            buildAccountOption(
                              iconPath: 'assets/icons/user.png',
                              title: 'Profile Details',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  toLeftTransition(const AcademicAdminAccountDetails()),
                                );
                              },
                            ),

                            // Reported Issues
                            buildAccountOption(
                              iconPath: 'assets/icons/report.png',
                              title: 'Reported Issues',
                              onTap: () {
                                // TODO: Navigate to Report Issues Page
                              },
                            ),

                            // Change Password
                            buildAccountOption(
                              iconPath: 'assets/icons/padlock.png',
                              title: 'Change Password',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  toLeftTransition(
                                    AcademicAdminChangePassword(),
                                  ),
                                );
                              },
                            ),

                            // Log Out
                            buildAccountOption(
                              iconPath: 'assets/icons/logout.png',
                              title: 'Log Out',
                              onTap: () {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  title: "Logout",
                                  text: "Are you sure you want to logout?",
                                  confirmBtnText: "Yes",
                                  cancelBtnText: "No",
                                  onConfirmBtnTap: () => signOutUser(context),
                                );
                              },
                              iconColor: const Color.fromARGB(255, 255, 17, 0),
                              textColor: const Color.fromARGB(255, 255, 62, 48),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ]),
      ),
    );
  }
}

// Add this method inside your _AcademicAdminProfilePageState class
Widget buildAccountOption({
  required String iconPath,
  required String title,
  required VoidCallback onTap,
  Color? iconColor,
  Color? textColor,
}) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 20,
                  height: 20,
                  color: iconColor,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Divider(
        color: Colors.black.withOpacity(0.06),
        thickness: 1,
      ),
      const SizedBox(height: 12),
    ],
  );
}
