import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/bottom_nav/academician_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_profile/academic_admin_account_details.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_profile/academic_admin_email_sended.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/registration/signup_page/academic_admin_greets_page.dart';
import 'package:smartclass_fyp_2024/features/admin/manage_profile/admin_account_details.dart';
import 'package:smartclass_fyp_2024/features/admin/manage_profile/admin_email_sended.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_profile/email_sended.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_profile/lecturer_account_details.dart';
import 'package:smartclass_fyp_2024/features/student/views/manage_profile/student_account_details.dart';
import 'package:smartclass_fyp_2024/features/student/views/manage_profile/student_email_sended.dart';
import 'package:smartclass_fyp_2024/features/super_admin/bottom_navbar/superadmin_bottom_nav.dart';
import 'package:smartclass_fyp_2024/features/super_admin/views/super_admin_signin.dart';
import 'package:smartclass_fyp_2024/shared/data/models/role.dart';
import 'package:smartclass_fyp_2024/features/admin/bottom_nav/admin_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/features/admin/registeration/signup_page/admin_greets_page.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/registration/signin_page/checkEmail_page.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/registration/signup_page/lecturer_greets_page.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/template/lecturer_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/features/student/views/registration/signin_page/student_greets_page.dart';
import 'package:smartclass_fyp_2024/shared/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import 'package:smartclass_fyp_2024/features/student/views/template/student_bottom_navbar.dart';

class AuthService {
  //SIGNUP
  Future<void> signUpUser({
    required BuildContext context,
    required WidgetRef ref,
    // required int userId,
    required String userName,
    required String name,
    required String userEmail,
    required String userPassword,
    required String confirmPassword,
    required int roleId,
    required String externalId,
  }) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      User _user = User(
        // userId: userId,
        userName: userName,
        name: name,
        userEmail: userEmail,
        userPassword: userPassword,
        confirmPassword: confirmPassword,
        token: '',
        roleId: roleId,
        externalId: externalId,
      );

      http.Response res = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/signup'),
        body: _user.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      httpErrorHandle(
        response: res,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          showSnackBar(
              context, 'Account created! Check your email for verification!');

          //Direct to Greet page back
          //Student
          if (roleId == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              toRightTransition(
                const StudentGreetsPage(),
              ),
              (route) => false,
            );

            //Lecturer
          } else if (roleId == 2) {
            Navigator.pushAndRemoveUntil(
              context,
              toRightTransition(
                const LecturerGreetsPage(),
              ),
              (route) => false,
            );

            //Staff
          } else if (roleId == 3) {
            Navigator.pushAndRemoveUntil(
              context,
              toRightTransition(
                const AdminGreetsPage(),
              ),
              (route) => false,
            );
          } else if (roleId == 4) {
            Navigator.pushAndRemoveUntil(
              context,
              toRightTransition(
                const AcademicAdminGreetsPage(),
              ),
              (route) => false,
            );
          }
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  //LOGIN
  Future<void> loginUser({
    required BuildContext context,
    required WidgetRef ref,
    required String userEmail,
    required String userPassword,
    required int roleId,
  }) async {
    try {
      final navigator = Navigator.of(context);

      http.Response res = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/signin/$roleId'),
        body:
            jsonEncode({'userEmail': userEmail, 'userPassword': userPassword}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      httpErrorHandle(
        response: res,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () async {
          showSnackBar(context, jsonDecode(res.body)['message']);
          //Store Token Locally
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final userData = jsonDecode(res.body);

          // Check if token is present and not null
          final token = userData['token'];
          if (token != null && token is String) {
            await prefs.setString('x-auth-token', token);
          } else {
            showSnackBar(context, 'Login failed: No token received.');
            return;
          }

          // print(userData); //Debugging Purposes

          //Set User Provider
          ref
              .read(userProvider.notifier)
              .setUserFromModel(User.fromJson(res.body));
          await prefs.setString('x-auth-token', userData['token']);

          // Debug print to check if token is saved
          // print('Token saved: ${userData['token']}'); //Debugging Purposes

          //Navigate to Lecturer Page if user is lecturer
          if (userData['roleId'] == Role.lecturer) {
            navigator.pushAndRemoveUntil(
              toLeftTransition(
                const LectBottomNavBar(initialIndex: 0),
              ),
              (route) => false,
            );

            //Navigate to Student Page if user is student
          } else if (userData['roleId'] == Role.student) {
            navigator.pushAndRemoveUntil(
              toLeftTransition(
                const StudentBottomNavbar(
                  initialIndex: 0,
                ),
              ),
              (route) => false,
            );

            //Navigate to Admin Page if user is admin
          } else if (userData['roleId'] == Role.staff) {
            navigator.pushAndRemoveUntil(
              toLeftTransition(
                const AdminBottomNavbar(initialIndex: 0),
              ),
              (route) => false,
            );
          } else if (userData['roleId'] == Role.academicStaff) {
            navigator.pushAndRemoveUntil(
              toLeftTransition(
                const AcademicianBottomNavbar(initialIndex: 0),
              ),
              (route) => false,
            );
          } else if (userData['roleId'] == Role.superadmin) {
            navigator.pushAndRemoveUntil(
              toLeftTransition(
                const SuperadminBottomNav(initialIndex: 0),
              ),
              (route) => false,
            );
          }

          // print(userData['roleId']); //Debugging Purposes
        },
      );
    } catch (e) {
      //Debug
      print(e);
      //Print more details
      // ignore: use_build_context_synchronously
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  //Get User Data
  // In auth_service.dart
  Future<User?> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token') ?? '';

      //Debugging Purposes
      // if (token.isEmpty) {
      //   print("Token is empty");
      //   return null;
      // }

      // Validate Token
      var tokenRes = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/tokenIsValid'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      var tokenValidationResponse = jsonDecode(tokenRes.body);

      // Debugging Purposes
      // print('Token validation response: $tokenValidationResponse');

      if (tokenValidationResponse['isValid'] == true) {
        // Fetch User Data
        http.Response userRes = await http.get(
          Uri.parse('${ApiConstants.baseUrl}/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        // Debugging Purposes
        // print('User data response: ${userRes.body}'); // Log user

        // Handle User Data Parsing
        try {
          return User.fromJson(userRes.body);
        } catch (e) {
          // Debugging Purposes
          // print('Error parsing user data: $e');
          return null;
        }
      } else {
        // Debugging Purposes
        // print("Token is not valid");
        return null;
      }
    } catch (e) {
      // Debugging Purposes
      // print("Error fetching user data: $e");
      return null;
    }
  }

  Future<void> signOut(BuildContext context, int roleId) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('x-auth-token', '');
    // ref.read(userProvider.notifier).logout(); // Reset user state in Riverpod

    // Show Flushbar and navigate after it is dismissed
    Flushbar(
      message: "Successfully signed out",
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(8),
      backgroundColor: Colors.green,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
    ).show(context).then((_) {
      //Navigate to Lecturer Page if user is lecturer
      if (roleId == Role.lecturer) {
        navigator.pushAndRemoveUntil(
          toLeftTransition(
            const LecturerGreetsPage(),
          ),
          (route) => false,
        );

        //Navigate to Student Page if user is student
      } else if (roleId == Role.student) {
        navigator.pushAndRemoveUntil(
          toLeftTransition(
            const StudentGreetsPage(),
          ),
          (route) => false,
        );

        //Navigate to Admin Page if user is admin
      } else if (roleId == Role.staff) {
        navigator.pushAndRemoveUntil(
          toLeftTransition(
            const AdminGreetsPage(),
          ),
          (route) => false,
        );
      } else if (roleId == Role.academicStaff) {
        navigator.pushAndRemoveUntil(
          toLeftTransition(
            const AcademicAdminGreetsPage(),
          ),
          (route) => false,
        );
      } else if (roleId == Role.superadmin) {
        navigator.pushAndRemoveUntil(
          toLeftTransition(
            SuperAdminSignin(),
          ),
          (route) => false,
        );
      }
    });
  }

  Future<void> requestPasswordReset({
    required BuildContext context,
    required String userEmail,
    required bool isChangePassword,
    required int roleId,
  }) async {
    final navigator = Navigator.of(context);

    try {
      http.Response res = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/requestPasswordReset'),
        body: jsonEncode({'userEmail': userEmail}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, jsonDecode(res.body)['message']);
        },
      );

      if (res.statusCode == 200) {
        //Redirect to change password page
        if (isChangePassword) {
          if (roleId == Role.lecturer) {
            navigator.push(
              toLeftTransition(
                EmailSended(userEmail),
              ),
            );
          } else if (roleId == Role.student) {
            navigator.push(
              toLeftTransition(
                StudentEmailSended(userEmail),
              ),
            );
          } else if (roleId == Role.staff) {
            navigator.push(
              toLeftTransition(
                AdminEmailSended(userEmail),
              ),
            );
          } else if (roleId == Role.academicStaff) {
            navigator.push(
              toLeftTransition(
                AcademicAdminEmailSended(userEmail),
              ),
            );
          }
        } else {
          //Pass email to check email page
          //Redirect to check email page
          navigator.pushAndRemoveUntil(
            toLeftTransition(
              CheckEmailPage(userEmail),
            ),
            (route) => false,
          );
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Update User Profile
  Future<void> updateUserProfile({
    required BuildContext context,
    required int userId,
    required String userName,
    required String name,
  }) async {
    final navigator = Navigator.of(context);

    try {
      http.Response res = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/updateProfile'),
        body: jsonEncode({
          'userId': userId,
          'userName': userName,
          'name': name,
        }),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, jsonDecode(res.body)['message']);
        },
      );

      if (res.statusCode == 200) {
        if (userId == Role.lecturer) {
          //Redirect to lecturer profile page
          navigator.pushAndRemoveUntil(
            toLeftTransition(
              const LecturerAccountDetails(),
            ),
            (route) => false,
          );
        } else if (userId == Role.student) {
          //Redirect to student profile page
          navigator.pushAndRemoveUntil(
            toLeftTransition(
              const StudentAccountDetails(),
            ),
            (route) => false,
          );
        } else if (userId == Role.staff) {
          //Redirect to admin profile page
          navigator.pushAndRemoveUntil(
            toLeftTransition(
              const AdminAccountDetails(),
            ),
            (route) => false,
          );
        } else if (userId == Role.academicStaff) {
          //Redirect to academic admin profile page
          navigator.pushAndRemoveUntil(
            toLeftTransition(
              const AcademicAdminAccountDetails(),
            ),
            (route) => false,
          );
        }
        // //Redirect to lecturer profile page
        // navigator.pushAndRemoveUntil(
        //   toLeftTransition(
        //     const LecturerAccountDetails(),
        //   ),
        //   (route) => false,
        // );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

final authServiceProvider = Provider((ref) => AuthService());
