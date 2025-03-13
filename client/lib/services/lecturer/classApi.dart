// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:convert'; // Provides JSON encoding and decoding functionality.
import 'package:flutter/material.dart'; // Flutter framework for UI components.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:smartclass_fyp_2024/models/lecturer/classSum_model.dart';
import '../../models/lecturer/class_models.dart'; // HTTP package for making API requests.

/// A class to handle API interactions for the application.
class Api {
  //Based url for WIFI Rumah
  // static const baseUrl = "http://192.168.0.99:3000/class/";

  //Based url for HOSTPOT MyPhone
  static const baseUrl = "http://172.20.10.2:3000/class/";

  // static const summarizationUrl = "http://172.20.10.2:3000/summarization/";

  //GET API Using provider to all classes data
  Stream<List<ClassModel>> getClasses() async* {
    while (true) {
      Response response = await get(Uri.parse("${baseUrl}viewclass"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['Data'];
        yield result.map(((e) => ClassModel.fromJson(e))).toList();
      } else {
        throw Exception("Failed to load classes");
      }
      await Future.delayed(const Duration(seconds: 5)); // Polling interval
    }
  }

  //POST API
  /// Sends a POST request to add a class to the backend database.
  ///
  /// [cdata] is a Map containing class data to be sent to the backend.
  /// Example:
  /// ```
  /// {
  ///   'courseCode': 'CS101',
  ///   'className': 'Introduction to Programming',
  ///   'date': '11/12/2024',
  ///   'timeStart': '3:00 PM',
  ///   'timeEnd': '5:00 PM',
  ///   'classLocation': 'Room 101'
  /// }
  /// ```
  static addClass(ClassModel data) async {
    // Print the input data for debugging purposes.
    // ignore: avoid_print
    print(data);

    // Construct the full URL for the "add_class" API endpoint.
    var url = Uri.parse("${baseUrl}addclass");

    try {
      // Send a POST request to the backend with JSON-encoded class data.
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        }, // Set the header to indicate JSON data.
        body: jsonEncode(data.toJson()), // Encode the data as a JSON string.
      );

      // Check if the server responded with a success status code (200 OK).
      if (res.statusCode == 200) {
        // Decode and print the response body for debugging purposes.
        var data = jsonDecode(res.body.toString());
        // ignore: avoid_print
        print(data);
        return data;
      } else {
        // Print an error message with the status code and response body.
        print("Failed to upload DATA: ${res.statusCode}");
        print("Response: ${res.body}");
        return null;
      }
    } catch (e) {
      // Print any errors encountered during the API request.
      debugPrint("Error: $e");
      return null;
    }
  }

  //PUT API
  /// Sends a PUT request to update a class in the backend database.
  /// [url] is the URL of the API endpoint to update the class.
  /// [data] is the class data to be updated.
  /// Example:
  /// ```
  /// {
  ///   'id': 1,
  ///   'courseCode': 'CS101',
  ///   'className': 'Introduction to Programming',
  ///   'date': '11/12/2024',
  ///   'timeStart': '3:00 PM',
  ///   'timeEnd': '5:00 PM',
  ///   'classLocation': 'Room 101'
  /// }
  /// ```
  static updateClass(String url, ClassModel data) async {
    try {
      var uri = Uri.parse("${url}updateclass/${data.classId}");
      final res = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data.toJson()),
      );

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        // ignore: avoid_print
        print(responseData);
        print("Updating class with data: ${jsonEncode(data.toJson())}");
        return responseData;
      } else {
        print("Failed to update class: ${res.statusCode}");
        print("Response: ${res.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  //DELETE API
  /// Sends a DELETE request to delete a class from the backend database.
  /// [url] is the URL of the API endpoint to delete the class.
  /// [id] is the ID of the class to be deleted.
  static deleteClass(String url, int id) async {
    try {
      var uri = Uri.parse("${url}deleteclass/$id");
      final res = await http.delete(uri);

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        // ignore: avoid_print
        print(responseData);
      } else {
        print("Failed to delete class: ${res.statusCode}");
        print("Response: ${res.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}

//Create a Provider Object
final classProvider = Provider<Api>((ref) =>
    Api()); //Entry point of the API macam share state , if there is change in UI . It will update the UI.
