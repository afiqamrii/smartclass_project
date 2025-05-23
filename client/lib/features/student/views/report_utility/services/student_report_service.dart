import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart'; // For detecting mime type
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/student/views/report_utility/views/student_view_reports_history.dart';

Future<void> submitReports(
    BuildContext context,
    String title,
    String description,
    String userId,
    int classroomId,
    File? selectedImage) async {
  if (title.isEmpty || description.isEmpty) {
    // Show error Flushbar
    Flushbar(
      message: 'Please fill in both title and description',
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
    return;
  }

  if (selectedImage != null) {
    // Send the title, description, and image to your backend
    final uri = Uri.parse("${ApiConstants.baseUrl}/report/create");
    final request = http.MultipartRequest("POST", uri)
      ..fields['title'] = title
      ..fields['description'] = description
      ..fields['classroomId'] = classroomId.toString()
      ..fields['userId'] = userId;

    // Add the image file to the request
    var fileBytes = await selectedImage.readAsBytes();
    String mimeType = lookupMimeType(selectedImage.path) ?? 'image/jpeg';
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      fileBytes,
      filename: 'report_image.jpg', // Provide a filename
      contentType: MediaType.parse(mimeType),
    ));

    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      // Show success Flushbar
      await Flushbar(
        message: 'Report submitted successfully!',
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

      // Redirect to the report page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ViewReportsHistory(),
        ),
      );
    } else {
      // Show error Flushbar
      Flushbar(
        message: 'Failed to submit report: ${response.statusCode}',
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
  } else {
    // Show error Flushbar
    Flushbar(
      message: 'Please select an image to upload',
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

//Update Report
Future<void> updateReports(
  BuildContext context,
  int reportId,
  String title,
  String description,
  String userId,
  int classroomId,
  File? selectedImage,
  String currentImageUrl,
) async {
  if (title.isEmpty || description.isEmpty) {
    Flushbar(
      message: 'Please fill in both title and description',
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red.shade600,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(Icons.error, color: Colors.white),
    ).show(context);
    return;
  }

  print('Selected Image: $selectedImage');
  print("Data to be sent: $title, $description, $userId, $classroomId");

  if (selectedImage == null) {
    // Update without new image
    final uri = Uri.parse(
        "${ApiConstants.baseUrl}/report/updatereport/withoutimage/$reportId");
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
        'classroomId': classroomId.toString(),
        'userId': userId,
      }),
    );
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      await Flushbar(
        message: 'Report updated successfully!',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green.shade600,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      ).show(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ViewReportsHistory(),
        ),
      );
    } else {
      Flushbar(
        message: 'Failed to update report: ${response.statusCode}',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade600,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
    }
  } else {
    // Send the title, description, and image to your backend
    final uri =
        Uri.parse("${ApiConstants.baseUrl}/report/updatereport/$reportId");
    final request = http.MultipartRequest("PUT", uri)
      ..fields['title'] = title
      ..fields['description'] = description
      ..fields['classroomId'] = classroomId.toString()
      ..fields['userId'] = userId;

    // Add the image file to the request
    var fileBytes = await selectedImage.readAsBytes();
    String mimeType = lookupMimeType(selectedImage.path) ?? 'image/jpeg';
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      fileBytes,
      filename: 'report_image.jpg', // Provide a filename
      contentType: MediaType.parse(mimeType),
    ));

    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      // Show success Flushbar
      await Flushbar(
        message: 'Report submitted successfully!',
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

      // Redirect to the report page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ViewReportsHistory(),
        ),
      );
    } else {
      Flushbar(
        message: 'Failed to update report: ${response.statusCode}',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade600,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
    }
  }
}
