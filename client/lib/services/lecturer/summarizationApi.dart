// ignore: file_names
import 'dart:convert'; // Provides JSON encoding and decoding functionality.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:smartclass_fyp_2024/models/lecturer/summarization_models.dart';

class Summarizationapi {
  //Based url
  static const baseUrl = "http://192.168.0.99:3000/classSummarization/";

  // Get Summarization
  Future<List<SummarizationModels>> getSummarization(int classId) async {
    Response response =
        await get(Uri.parse("${baseUrl}accesssummarization/$classId"));

    //Check whether the response is successful or not.
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['Data'];
      return data.map((json) => SummarizationModels.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load summarization');
    }
  }
  // static Future<List<SummarizationModels>> getSummarization(
  //     String endpoint) async {
  //   final url = Uri.parse("${url}viewclass");
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body)['Data'];
  //     return data.map((json) => SummarizationModels.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load summarization');
  //   }
  // }
}

//Create a Provider Object
final classProviderSummarization = Provider<Summarizationapi>((ref) =>
    Summarizationapi()); //Entry point of the API macam share state , if there is change in UI . It will update the UI.