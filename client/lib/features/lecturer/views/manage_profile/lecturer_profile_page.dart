import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_profile/lecturer_account_details.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/services/auth_services.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class LecturerProfilePage extends ConsumerStatefulWidget {
  const LecturerProfilePage({super.key});

  @override
  ConsumerState<LecturerProfilePage> createState() =>
      _LecturerProfilePageState();
}

class _LecturerProfilePageState extends ConsumerState<LecturerProfilePage> {
  void signOutUser(BuildContext context) {
    AuthService().signOut(context, 2);
  }

  @override
  Widget build(BuildContext context) {
    //Get user data
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
      body: SafeArea(
        child: Column(
          children: [
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
                                  "Lecturer",
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
            Expanded(
              child: Container(
                width: double.infinity,
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Column(
                          children: [
                            //1st Profile Details Button
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  toLeftTransition(
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
                                      const Column(
                                        children: [
                                          Text(
                                            "Profile Details",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //Make a horizontal line
                            Divider(
                              color: Colors.black.withOpacity(0.06),
                              thickness: 1,
                            ),
                            const SizedBox(height: 12),
                            //2nd Report Issues Button
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         const LecturerEditProfile(),
                                //   ),
                                // );
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
                                      const Column(
                                        children: [
                                          Text(
                                            "Reported Issues",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //Make a horizontal line
                            Divider(
                              color: Colors.black.withOpacity(0.06),
                              thickness: 1,
                            ),
                            const SizedBox(height: 12),
                            //3nd Log Out
                            GestureDetector(
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/logout.png',
                                        width: 20,
                                        height: 20,
                                        color: const Color.fromARGB(
                                            255, 255, 17, 0),
                                      ),
                                      const SizedBox(width: 10),
                                      const Column(
                                        children: [
                                          Text(
                                            "Log Out",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 255, 62, 48),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //Make a horizontal line
                            Divider(
                              color: Colors.black.withOpacity(0.06),
                              thickness: 1,
                            ),
                            // const SizedBox(height: 12),

                            // const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      //End of List of button / Features of account settings
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
