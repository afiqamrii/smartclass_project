import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/models/create_classroom_mode.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classroom_models.dart';

class ManageClassroomApi {
  //Add classroom
  static addClassroom(
      BuildContext context, CreateClassroomMode classroom) async {
    try {
      //Get URL
      var uri = Uri.parse("${ApiConstants.baseUrl}/classroom/addclassroom");
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(classroom.toJson()),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        await Flushbar(
          message: 'Classroom added successfully! ',
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
      } else if (data['message'] == "Classroom name already exists.") {
        // final err = json.decode(res.body);
        await Flushbar(
          message:
              "Classroom name already exists. Please change classroom name.",
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
        ).show(context);

        return null;
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

  //Fetch all soft deleted classrooms
  static Future<List<ClassroomModels>> fetchSoftDeletedClassrooms() async {
    final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/classroom/getDeletedClassroom'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Extract the "Data" key and ensure it is a list
      if (jsonData.containsKey('Data') && jsonData['Data'] is List) {
        return (jsonData['Data'] as List)
            .map((course) => ClassroomModels.fromJson(course))
            .toList();
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a list');
      }
    } else {
      throw Exception('Failed to load courses');
    }
  }

  //Soft Delete classroom
  static deleteClassroom(BuildContext context, int classroomId) async {
    try {
      //Get URL
      var uri = Uri.parse(
          "${ApiConstants.baseUrl}/classroom/deleteclassroom/$classroomId");
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
              'Classroom deleted successfully! Note that it is soft deleted, meaning it is not completely deleted and can still be restored.',
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

  //Restore classroom
  static restoreClassroom(BuildContext context, int classroomId) async {
    try {
      //Get URL
      var uri = Uri.parse(
          "${ApiConstants.baseUrl}/classroom/restoreclassroom/$classroomId");
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
          message: 'Classroom restored successfully!.',
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
  static deleteClassroomPermanently(
      BuildContext context, int classroomId) async {
    try {
      //Get URL
      var uri =
          Uri.parse("${ApiConstants.baseUrl}/classroom/delete/$classroomId");
      final res = await http.delete(uri);

      if (res.statusCode == 200) {
        await Flushbar(
          message: 'Classroom deleted successfully!.',
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
