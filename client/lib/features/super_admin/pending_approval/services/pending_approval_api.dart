import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PendingApprovalApi {
  //Function to update the enrollment request status
  static Future<void> approveUser(int userId, String token,
      BuildContext context, String status, String email) async {
    try {
      final response = await http.put(
        Uri.parse(
            '${ApiConstants.baseUrl}/superadmin/updateapprovalstatus/$userId'),
        headers: {
          'x-auth-token':
              token, // Pass the token as a header to verify authentication for super admin
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'is_approved': status, 'user_email': email}),

        //Debug
        // print(response.body);
      );

      //Debug
      print(response.body);

      if (response.statusCode == 200) {
        //If the send is Approved
        if (status == "Approved") {
          await Flushbar(
            message: 'User approved successfully!',
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green.shade600,
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            flushbarPosition: FlushbarPosition.TOP,
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
          ).show(context);
          //Navigate to pending approval screen
          Navigator.pop(context);
        } else {
          await Flushbar(
            message: 'User rejected successfully!',
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green.shade600,
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            flushbarPosition: FlushbarPosition.TOP,
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
          ).show(context);
          //Navigate to pending approval screen
          Navigator.pop(context);
        }
      } else {
        final jsonData = jsonDecode(response.body);
        final error = jsonData['error'] ?? 'Failed to update request.';
        await Flushbar(
          message: error,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red.shade600,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
        ).show(context);
      }
    } catch (e) {
      throw Exception(
        e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Could not approve user now. Please try again later.',
      );
    }
  }
}
