import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_account_details.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_edit_profile.dart';
import 'package:smartclass_fyp_2024/services/auth_services.dart';


class LecturerProfilePage extends StatelessWidget {
  const LecturerProfilePage({super.key});

  void signOutUser(BuildContext context) {
    AuthService().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
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
              height: MediaQuery.of(context).size.width * 0.3,
              child: const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Column(
                  children: [
                    Row(
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
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            //Put picture profiles hereee
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                'assets/pictures/compPicture.jpg',
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Name and email here
                                Text(
                                  "Hi, Dr. Afiq!",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Text(
                                  "afiqamri03@gmail.com",
                                  style: TextStyle(
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
                        //Start of List of button / Features of account settings
                        child: Column(
                          children: [
                            //1st Profile Details Button
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
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //Make a horizontal line
                            Divider(
                              color: Colors.black.withOpacity(0.15),
                              thickness: 1,
                            ),
                            const SizedBox(height: 12),
                            //2nd Report Issues Button
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
                                      const Column(
                                        children: [
                                          Text(
                                            "Report Issues",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
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
                            const SizedBox(
                              height: 12,
                            ),
                            //Make a horizontal line
                            Divider(
                              color: Colors.black.withOpacity(0.15),
                              thickness: 1,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      //End of List of button / Features of account settings
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.width * 0.8,
                      // ),
                      //Logout Button
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
            ),
          ],
        ),
      ),
    );
  }
}
