// ignore: file_names
import 'dart:convert'; // Provides JSON encoding and decoding functionality.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/models/lecturer/summarization_models.dart';

class Summarizationapi {
  //Based url for WIFI Rumah
  // static const baseUrl = "http://192.168.0.99:3000/classSummarization/";

  //Based url for update summarization
  // static const updateUrl = "http://192.168.0.99:3000/classrecording/";

  // //Based url for HOSTPOT MyPhone
  static const baseUrl = "http://172.20.10.2:3000/classSummarization/";

  //domain for hotspot
  //Based url for update summarization
  static const updateUrl = "http://172.20.10.2:3000/classrecording/";

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

  //PUT API to add summarized text to the database
  // Endpoint: /classrecording/updatesummarization
  /// Update Summarization data (PUT API)
  Future<void> updateSummarization(int classId, String summarizedText) async {
    try {
      final uri = Uri.parse("${updateUrl}editsummarizedtext");
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({"summarizedText": summarizedText, "classId": classId}),
      );

      if (response.statusCode == 200) {
        print("Update successful: ${jsonDecode(response.body)}");
      } else {
        print(
            "Failed to update summarization: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception in updateSummarization: $e");
    }
  }
}

//Create a Provider Object
final classProviderSummarization = Provider<Summarizationapi>((ref) =>
    Summarizationapi()); //Entry point of the API macam share state , if there is change in UI . It will update the UI.
