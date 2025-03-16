import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/login_page/lecturer_greets_page.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/template/lecturer_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/models/lecturer/user.dart';
import 'package:smartclass_fyp_2024/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclass_fyp_2024/widget/pageTransition.dart';

class AuthService {
  //BASE URL
  static const baseUrl = "http://172.20.10.2:3000/api";

  //GET USER DATA
  static const tokenAuthUrl = "http://172.20.10.2:3000";

  //SIGNUP
  Future<void> signUpUser({
    required BuildContext context,
    required WidgetRef ref,
    required int userId,
    required String userName,
    required String userEmail,
    required String userPassword,
    required String confirmPassword,
    required int roleId,
  }) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      User _user = User(
        userId: userId,
        userName: userName,
        userEmail: userEmail,
        userPassword: userPassword,
        token: '',
        userRole: roleId,
      );

      http.Response res = await http.post(
        Uri.parse('$baseUrl/signup'),
        body: _user.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      httpErrorHandle(
        response: res,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          showSnackBar(
              context, 'Account created! Login with the same credentials!');
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
        Uri.parse('$baseUrl/signin'),
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

          navigator.pushAndRemoveUntil(
            toLeftTransition(const LectBottomNavBar(initialIndex: 0)),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Get User Data
  Future<void> getUserData(WidgetRef ref) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token') ?? '';

      // Debug print to check if token is retrieved
      // print('Token retrieved: $token'); //Debugging Purposes

      // if (token == null) {
      //   prefs.setString('x-auth-token', '');
      // }

      // Check if the token is valid
      var tokenRes = await http.post(
        Uri.parse('$tokenAuthUrl/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      // print("Pass here"); //Debugging Purposes

      var response = jsonDecode(tokenRes.body);

      // If the token is valid, fetch user data
      if (response['isValid'] == true) {
        // print("Token valid!"); //Debugging Purposes

        http.Response userRes = await http.get(
          Uri.parse('$tokenAuthUrl/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        //Set User Data in Provider
        ref
            .read(userProvider.notifier)
            .setUserFromModel(User.fromJson(userRes.body));

        //Debugging Purposes
        // print("User set: ${userRes.body}");
        // print("Provider user: ${ref.read(authProvider)}");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching user data: $e");
    }
  }

  Future<void> signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('x-auth-token', '');
    // ref.read(userProvider.notifier).logout(); // Reset user state in Riverpod

    navigator.pushAndRemoveUntil(
      upTransition(
        const LecturerGreetsPage(),
      ),
      (route) => false,
    );
  }
}

final authServiceProvider = Provider((ref) => AuthService());
