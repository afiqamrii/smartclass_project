import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';

class Classsessionapi {
  //GET API Using provider to all classes data
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
}

final classProvider = Provider<Classsessionapi>((ref) => Classsessionapi());
