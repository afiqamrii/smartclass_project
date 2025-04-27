// ignore: file_names
import 'dart:convert'; // Provides JSON encoding and decoding functionality.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classSum_model.dart';
import 'package:smartclass_fyp_2024/shared/data/models/summarization_models.dart';

class Summarizationapi {

  //GET API Using provider to the class with summarization status
  Stream<List<ClassSumModel>> getClassesWithSummarization(String lecturerId) async* {
    while (true) {
      Response response = await get(Uri.parse(
          "${ApiConstants.baseUrl}/summarization/viewSummarizationStatus/$lecturerId"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['Data'];
        yield result.map(((e) => ClassSumModel.fromJson(e))).toList();
      } else {
        throw Exception("Failed to load summarization");
      }
      await Future.delayed(const Duration(seconds: 5)); // Polling interval
    }
  }

  // Get Summarization with id
  Stream<List<SummarizationModels>> getSummarization(int classId) async* {
    while (true) {
      Response response = await get(Uri.parse(
          "${ApiConstants.baseUrl}/summarization/accesssummarization/$classId"));

      //Check whether the response is successful or not.
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['Data'];
        yield data.map((json) => SummarizationModels.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load summarization');
      }
      await Future.delayed(const Duration(seconds: 5)); // Polling interval
    }
  }

  //PUT API to add summarized text to the database
  // Endpoint: /classrecording/updatesummarization
  /// Update Summarization data (PUT API)
  static Future<bool> updateSummarization(
      int classId, String summarizedText) async {
    try {
      final uri =
          Uri.parse("${ApiConstants.baseUrl}/summarization/editsummarizedtext");
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({"summarizedText": summarizedText, "classId": classId}),
      );

      if (response.statusCode == 200) {
        // print("Update successful: ${jsonDecode(response.body)}");
        return true;
      } else {
        // print(
        //     "Failed to update summarization: ${response.statusCode} - ${response.body}");
        // print("Class ID: $classId");
        // print("Summarized Text: $summarizedText");
        return false;
      }
    } catch (e) {
      // print("Exception in updateSummarization: $e");
      return false;
    }
  }

  //PUT API to update publish status
  // Endpoint: /classrecording/updatepublishstatus
  /// Update Publish Status (PUT API)
  static Future<bool> updatePublishStatus(
      int classId, String publishStatus) async {
    try {
      final uri = Uri.parse(
          "${ApiConstants.baseUrl}/summarization/updatepublishstatus");
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"publishStatus": publishStatus, "classId": classId}),
      );

      if (response.statusCode == 200) {
        // print("Update successful: ${jsonDecode(response.body)}");
        return true;
      } else {
        // print(
        //     "Failed to update publish status: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      // print("Exception in updatePublishStatus: $e");
      return false;
    }
  }
}

//Create a Provider Object
final classProviderSummarization = Provider<Summarizationapi>((ref) =>
    Summarizationapi()); //Entry point of the API macam share state , if there is change in UI . It will update the UI.
