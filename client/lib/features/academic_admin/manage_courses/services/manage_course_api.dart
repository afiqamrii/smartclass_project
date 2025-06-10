import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/models/create_course_models.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/course_model.dart';

class ManageCourseApi {
  // Add course
  static Future<void> addCourse(
      BuildContext context, CreateCourseModels courseData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/course/addcourse'),
        body: courseData.toJson(),
      );

      if (response.statusCode == 200) {
        await Flushbar(
          message: 'Course added successfully! ',
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ).show(context);

        //Refresh page to update the list
        Navigator.pop(context, true);
      } else {
        final err = json.decode(response.body);
        await Flushbar(
          message: err['message']?.toString() ?? 'An error occurred.',
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 5),
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
      debugPrint("Error: $e"); //Print error
      await Flushbar(
        message: 'Something went wrong! ',
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 5),
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

  // Edit course
  static Future<void> editCourse(
      BuildContext context, CreateCourseModels courseData, int courseId) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/course/editcourse/$courseId'),
        body: courseData.toJson(),
      );

      if (response.statusCode == 200) {
        await Flushbar(
          message: 'Course edited successfully! ',
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ).show(context);

        //Refresh page to update the list
        Navigator.pop(context, true);
      } else {
        final err = json.decode(response.body);
        await Flushbar(
          message: err['message']?.toString() ?? 'An error occurred.',
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 5),
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
      debugPrint("Error: $e"); //Print error
      await Flushbar(
        message: 'Something went wrong! ',
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 5),
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

  //Soft delete courses
  static softDeleteCourse(BuildContext context, int courseId) async {
    try {
      //Get URL
      var uri =
          Uri.parse("${ApiConstants.baseUrl}/course/softdelete/$courseId");
      final res = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        //Pass data
        body: json.encode({"is_active": "No"}),
      );

      if (res.statusCode == 200) {
        await Flushbar(
          message:
              'Course deleted successfully! Note that it is soft deleted, meaning it is not completely deleted and can still be restored.',
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ).show(context);

        Navigator.pop(context, true);
      } else {
        final err = json.decode(res.body);
        await Flushbar(
          message: err['message']?.toString() ?? 'An error occurred.',
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
        ).show(context);

        return null;
      }
    } catch (e) {
      debugPrint("Error: $e"); //Print error
      return null;
    }
  }

  static Future<List<CourseModel>> fetchSoftDeletedCourses() async {
    final response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}/course/getDeletedCourse'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Extract the "Data" key and ensure it is a list
      if (jsonData.containsKey('Data') && jsonData['Data'] is List) {
        return (jsonData['Data'] as List)
            .map((course) => CourseModel.fromJson(course))
            .toList();
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a list');
      }
    } else {
      throw Exception('Failed to load courses');
    }
  }

  static restoreCourses(BuildContext context, int courseId) async {
    try {
      //Get URL
      var uri =
          Uri.parse("${ApiConstants.baseUrl}/course/restorecourse/$courseId");
      final res = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        //Pass data
        body: json.encode({"is_active": "Yes"}),
      );

      if (res.statusCode == 200) {
        await Flushbar(
          message: 'Course restored successfully!.',
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ).show(context);

        Navigator.pop(context, true);
      } else {
        final err = json.decode(res.body);
        await Flushbar(
          message: err,
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
        ).show(context);

        return null;
      }
    } catch (e) {
      debugPrint("Error: $e"); //Print error
      return null;
    }
  }

  //Function to completely delete classroom
  static deleteClassroomPermanently(BuildContext context, int courseId) async {
    try {
      //Get URL
      var uri = Uri.parse("${ApiConstants.baseUrl}/course/delete/$courseId");
      final res = await http.delete(uri);

      if (res.statusCode == 200) {
        await Flushbar(
          message: 'Course deleted successfully!.',
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ).show(context);

        Navigator.pop(context, true);
      } else {
        final err = json.decode(res.body);
        await Flushbar(
          message: err,
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
        ).show(context);

        return null;
      }
    } catch (e) {
      debugPrint("Error: $e"); //Print error
      return null;
    }
  }
}
