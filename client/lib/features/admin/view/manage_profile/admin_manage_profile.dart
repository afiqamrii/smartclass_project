import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_profile/lecturer_account_details.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_profile/lecturer_edit_profile.dart';
import 'package:smartclass_fyp_2024/shared/data/services/auth_services.dart';

class AdminManageProfile extends ConsumerStatefulWidget {
  const AdminManageProfile({super.key});

  @override
  ConsumerState<AdminManageProfile> createState() => _AdminManageProfileState();
}

class _AdminManageProfileState extends ConsumerState<AdminManageProfile> {
  // ignore: unused_field
  bool _isRefreshing = false; // Add loading state

  void signOutUser(BuildContext context) {
    AuthService().signOut(context, 1); //1 for student
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() {
      _isRefreshing = true; // Set loading state to true
    });

    // Invalidate the provider to trigger loading state
    // ref.invalidate(classDataProvider);
    // ref.invalidate(classDataProviderSummarizationStatus);
    await ref.read(userProvider.notifier).refreshUserData();

    // Wait for new data to load
    await Future.delayed(
      const Duration(seconds: 1),
    );

    setState(() {
      _isRefreshing = false; // Set loading state to false
    });
  }

  @override
  Widget build(BuildContext context) {
    //Data provider for user data
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.black87,
      // appBar: AppBar(
      //   backgroundColor: Colors.amber,
      //   title: const Padding(
      //     padding: EdgeInsets.only(left: 5.0),
      //     child: Text(
      //       "Profile",
      //       style: TextStyle(
      //         fontSize: 27,
      //       ),
      //     ),
      //   ),
      // ),
      // ignore: sized_box_for_whitespace
      body: LiquidPullToRefresh(
        color: Colors.black87,
        onRefresh: () => _handleRefresh(ref),
        showChildOpacityTransition: false,
        child: ListView(
          children: [
            Column(
              children: [
                // ignore: sized_box_for_whitespace
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.3,
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
                                      "Hi, ${user.userName}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      user.userEmail,
                                      style: const TextStyle(
                                        fontSize: 15,
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
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 1,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Account Settings",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: [
                              // Profile Details Button
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LecturerAccountDetails(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/user.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "Profile Details",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Divider(
                                color: Colors.black.withOpacity(0.15),
                                thickness: 1,
                              ),
                              const SizedBox(height: 12),
                              // Report Issues Button
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LecturerEditProfile(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/report.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "Report Issues",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Divider(
                                color: Colors.black.withOpacity(0.15),
                                thickness: 1,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
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
                              label: const Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 17, 14, 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(54.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
