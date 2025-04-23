import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/student/models/check_attendance_models.dart';
import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';

class Classsessionapi {
  //GET API Using provider to all today classes data
  static Future<List<TodayclassCardModels>> getClasses() async {
    while (true) {
      Response response = await get(
          Uri.parse("${ApiConstants.baseUrl}/class/studentviewclass"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['Data'];
        return result.map(((e) => TodayclassCardModels.fromJson(e))).toList();
      } else {
        throw Exception("Failed to load classes");
      }
    }
  }

  //GET API to get upcoming classes
  static Future<List<TodayclassCardModels>> getUpcomingClasses() async {
    while (true) {
      Response response = await get(
          Uri.parse("${ApiConstants.baseUrl}/class/viewupcomingclass"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['Data'];
        return result.map(((e) => TodayclassCardModels.fromJson(e))).toList();
      } else {
        throw Exception("Failed to load classes");
      }
    }
  }

  //GET API to get past classes
  static Future<List<TodayclassCardModels>> getPastClasses() async {
    while (true) {
      Response response =
          await get(Uri.parse("${ApiConstants.baseUrl}/class/viewpastclass"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['Data'];
        return result.map(((e) => TodayclassCardModels.fromJson(e))).toList();
      } else {
        throw Exception("Failed to load classes");
      }
    }
  }

  //GET API for now class
  static Stream<List<TodayclassCardModels>> getNowClasses() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      Response response = await get(
          Uri.parse("${ApiConstants.baseUrl}/class/viewcurrentclass"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['Data'];
        yield result.map(((e) => TodayclassCardModels.fromJson(e))).toList();
      } else {
        throw Exception("Failed to load classes");
      }
    }
  }

  //Check studeent attendance statu
  //GET API for now class
  static Stream<List<CheckAttendanceModel>> checkAttendance(
      int classId, String studentId) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
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
