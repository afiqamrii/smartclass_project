import 'dart:convert';
import 'dart:io';
// import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/student/attendance/views/face_recognition_not_matched.dart';
import 'package:smartclass_fyp_2024/features/student/attendance/views/face_recognition_successfull.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class FaceRecognitionApi {
  Future<void> uploadFaceImage({
    required BuildContext context,
    required String studentId,
    required int classId,
    required File imageFile,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Lottie.asset(
          "assets/animations/attendanceLoading.json",
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );

    try {
      final uri = Uri.parse(
          "${ApiConstants.baseUrl}/clockInAttendance/verify/face/$studentId/$classId");
      final request = http.MultipartRequest('POST', uri);

      final bytes = await imageFile.readAsBytes();
      String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

      request.files.add(http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: 'face_image.jpg',
        contentType: MediaType.parse(mimeType),
      ));

      final response = await request.send();
      Navigator.of(context).pop(); // Close loading dialog

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody);

        // Check the success status
        if (jsonData['success'] == true) {
          await Flushbar(
            message: 'Face Verified Successfull!',
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

          Navigator.push(
            context,
            toLeftTransition(
              const FaceRecognitionSuccessfull(),
            ),
          );
        } else {
          Flushbar(
            message: 'Face not matched. Please try again later.',
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

          //Direct to failed to verify face page
          Navigator.push(
            context,
            toLeftTransition(
              const FaceRecognitionNotMatched(),
            ),
          );
        }
      } else {
        Flushbar(
          message: 'Face not matched. Please try again later.',
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

        //Direct to failed to verify face page
        Navigator.push(
          context,
          toLeftTransition(
            const FaceRecognitionNotMatched(),
          ),
        );
      }
    } on http.ClientException catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      Flushbar(
        message: 'An error occurred: ${e.message}',
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
  }
}
