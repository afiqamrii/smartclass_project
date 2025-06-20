import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/student/models/check_attendance_models.dart';
import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';

class Classsessionapi {
  //GET API Using provider to all today classes data
  static Future<List<TodayclassCardModels>> getClasses(String studentId) async {
    while (true) {
      Response response = await get(Uri.parse(
          "${ApiConstants.baseUrl}/class/studentviewclass/$studentId"));

      //Debugging: Print the response body
      // print("Student ID: $studentId");
      // print('Response body: ${response.body}');
      // Check if the response is successful
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['Data'];
        return result.map(((e) => TodayclassCardModels.fromJson(e))).toList();
      } else {
        throw Exception("Failed to load classes");
      }
    }
  }

  //GET API to get upcoming classes
  static Future<List<TodayclassCardModels>> getUpcomingClasses(
      String studentId) async {
    while (true) {
      Response response = await get(Uri.parse(
          "${ApiConstants.baseUrl}/class/viewupcomingclass/$studentId"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['Data'];
        return result.map(((e) => TodayclassCardModels.fromJson(e))).toList();
      } else {
        throw Exception("Failed to load classes");
      }
    }
  }

  //GET API to get past classes
  static Future<List<TodayclassCardModels>> getPastClasses(
      String studentId) async {
    while (true) {
      Response response = await get(
          Uri.parse("${ApiConstants.baseUrl}/class/viewpastclass/$studentId"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['Data'];
        return result.map(((e) => TodayclassCardModels.fromJson(e))).toList();
      } else {
        throw Exception("Failed to load classes");
      }
    }
  }

  //GET API for now class
  static Future<List<TodayclassCardModels>> getNowClasses(
      String studentId) async {
    Response response = await get(
        Uri.parse("${ApiConstants.baseUrl}/class/viewcurrentclass/$studentId"));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['Data'];
      return result.map(((e) => TodayclassCardModels.fromJson(e))).toList();
    } else {
      throw Exception("Failed to load classes");
    }
  }

  //Check studeent attendance statu
  //GET API for now class
  static Stream<List<CheckAttendanceModel>> checkAttendance(
      int classId, String studentId) async* {
    while (true) {
      // await Future.delayed(const Duration(seconds: 2));
      final response = await get(Uri.parse(
          "${ApiConstants.baseUrl}/clockInAttendance/checkattendance/$classId/$studentId"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final model = CheckAttendanceModel.fromJson(data);
        yield [model]; // Wrap in a list to match your provider's return type
      } else {
        throw Exception("Failed to check attendance");
      }
    }
  }
}

final classProvider = Provider<Classsessionapi>((ref) => Classsessionapi());
