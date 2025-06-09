import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/shared/data/models/classroom_models.dart';

class ManageClassroomApi {
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
}
