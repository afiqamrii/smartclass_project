// ignore: file_names
import 'dart:convert'; // Provides JSON encoding and decoding functionality.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_summarization/models/summary_prompt_models.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classSum_model.dart';
import 'package:smartclass_fyp_2024/shared/data/models/summarization_models.dart';

class Summarizationapi {
  //GET API Using provider to the class with summarization status
  Stream<List<ClassSumModel>> getClassesWithSummarization(
      String lecturerId) async* {
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

  // Sends the text and prompt to the backend for summarization
  static Future<void> summarizeText({
    required String transcriptionText,
    required int recordingId,
    required int classId,
    String? prompt, // The prompt is now optional
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/summarization/summarizetranscription'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'transcriptionText': transcriptionText,
        'recordingId': recordingId,
        'classId': classId,
        'prompt': prompt, // Can be null if lecturer doesn't provide one
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to trigger summarization. Server responded with ${response.statusCode}');
    }
  }

  //Student Get Summarization with id
  Stream<List<SummarizationModels>> getStudentSummarization(
      int classId) async* {
    while (true) {
      Response response = await get(Uri.parse(
          "${ApiConstants.baseUrl}/summarization/studentaccesssummarization/$classId"));

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

  static Future<List<SummaryPromptModels>> getSavedPrompts(
      String lecturerId) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/summarization/summaryprompt/$lecturerId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      //kdebug
      print(jsonData);

      // Extract the "Data" key and ensure it is a Map
      if (jsonData.containsKey('prompts') && jsonData['prompts'] is List) {
        return (jsonData['prompts'] as List)
            .map((course) => SummaryPromptModels.fromJson(course))
            .toList();
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a Map');
      }
    } else {
      throw Exception('Failed to load courses');
    }
  }

  static Future<void> savePrompt(String lecturerId, String prompt) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/summarization/savesummaryprompt'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'lecturerId': lecturerId, 'prompt': prompt}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save prompt');
    }
  }
}

//Create a Provider Object
final classProviderSummarization = Provider<Summarizationapi>((ref) =>
    Summarizationapi()); //Entry point of the API macam share state , if there is change in UI . It will update the UI.
