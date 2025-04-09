import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/data/models/role.dart';
import 'package:smartclass_fyp_2024/features/admin/bottom_nav/admin_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/features/admin/registeration/signup_page/admin_greets_page.dart';
import 'package:smartclass_fyp_2024/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/registration/signin_page/checkEmail_page.dart';
import 'package:smartclass_fyp_2024/features/lecturer/registration/signup_page/lecturer_greets_page.dart';
import 'package:smartclass_fyp_2024/features/lecturer/template/lecturer_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/data/models/user.dart';
import 'package:smartclass_fyp_2024/features/student/registration/signin_page/student_greets_page.dart';
import 'package:smartclass_fyp_2024/core/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclass_fyp_2024/core/widget/pageTransition.dart';
import 'package:smartclass_fyp_2024/features/student/template/student_bottom_navbar.dart';

class AuthService {
  //for WIFI Rumah
  //BASE URL
  // static const baseUrl = "http://192.168.0.99:3000/api";

  // //Reset Password
  // static const url = "http://192.168.0.99:3000";

  // //GET USER DATA
  // static const tokenAuthUrl = "http://192.168.0.99:3000";

  //Hotspot
  //BASE URL
  // static const baseUrl = "http://172.20.10.2:3000/api";

  // //Reset Password
  // static const url = "http://172.20.10.2:3000";

  // //GET USER DATA
  // static const tokenAuthUrl = "http://172.20.10.2:3000";

  //SIGNUP
  Future<void> signUpUser({
    required BuildContext context,
    required WidgetRef ref,
    // required int userId,
    required String userName,
    required String userEmail,
    required String userPassword,
    required String confirmPassword,
    required int roleId,
  }) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      User _user = User(
        // userId: userId,
        userName: userName,
        userEmail: userEmail,
        userPassword: userPassword,
        confirmPassword: confirmPassword,
        token: '',
        roleId: roleId,
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
  }) async {
    try {
      final navigator = Navigator.of(context);

      http.Response res = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/signin'),
        body:
            jsonEncode({'userEmail': userEmail, 'userPassword': userPassword}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      httpErrorHandle(
        response: res,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () async {
          //Store Token Locally
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final userData = jsonDecode(res.body);

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
          }

          // print(userData['roleId']); //Debugging Purposes
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Get User Data
  // In auth_service.dart
  Future<User?> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token') ?? '';

      if (token.isEmpty) {
        print("Token is empty");
        return null;
      }

      // Validate Token
      var tokenRes = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/tokenIsValid'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      var tokenValidationResponse = jsonDecode(tokenRes.body);
      print('Token validation response: $tokenValidationResponse');

      if (tokenValidationResponse['isValid'] == true) {
        // Fetch User Data
        http.Response userRes = await http.get(
          Uri.parse('${ApiConstants.baseUrl}/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        print('User data response: ${userRes.body}'); // Log user response

        // Handle User Data Parsing
        try {
          return User.fromJson(userRes.body);
        } catch (e) {
          print('Error parsing user data: $e');
          return null;
        }
      } else {
        print("Token is not valid");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<void> signOut(BuildContext context, int roleId) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('x-auth-token', '');
    // ref.read(userProvider.notifier).logout(); // Reset user state in Riverpod

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
    }
  }

  Future<void> requestPasswordReset({
    required BuildContext context,
    required String userEmail,
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
          showSnackBar(context, res.body);
        },
      );

      if (res.statusCode == 200) {
        //Pass email to check email page
        //Redirect to check email page
        navigator.pushAndRemoveUntil(
          toLeftTransition(
            CheckEmailPage(userEmail),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

final authServiceProvider = Provider((ref) => AuthService());
