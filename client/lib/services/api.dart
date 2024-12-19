// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:convert'; // Provides JSON encoding and decoding functionality.
import 'package:flutter/material.dart'; // Flutter framework for UI components.
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/models/class_models.dart'; // HTTP package for making API requests.

/// A class to handle API interactions for the application.
class Api {
  /// The base URL of the backend server's API.
  /// Replace the URL with your actual backend server address.
  static const baseUrl = "http://10.0.2.2:3000/class/";

  //POST API
  /// Sends a POST request to add a class to the backend database.
  ///
  /// [cdata] is a Map containing class data to be sent to the backend.
  /// Example:
  /// ```
  /// {
  ///   'courseCode': 'CS101',
  ///   'title': 'Introduction to Programming',
  ///   'date': '11/12/2024',
  ///   'timeStart': '3:00 PM',
  ///   'timeEnd': '5:00 PM',
  ///   'classLocation': 'Room 101'
  /// }
  /// ```
  static addClass(Map cdata) async {
    // Print the input data for debugging purposes.
    // ignore: avoid_print
    print(cdata);

    // Construct the full URL for the "add_class" API endpoint.
    var url = Uri.parse("${baseUrl}addclass");

    try {
      // Send a POST request to the backend with JSON-encoded class data.
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        }, // Set the header to indicate JSON data.
        body: jsonEncode(cdata), // Encode the data as a JSON string.
      );

      // Check if the server responded with a success status code (200 OK).
      if (res.statusCode == 200) {
        // Decode and print the response body for debugging purposes.
        var data = jsonDecode(res.body.toString());
        // ignore: avoid_print
        print(data);
      } else {
        // Print an error message with the status code and response body.
        print("Failed to upload DATA: ${res.statusCode}");
        print("Response: ${res.body}");
      }
    } catch (e) {
      // Print any errors encountered during the API request.
      debugPrint("Error: $e");
    }
  }

  //GET API
  /// Sends a GET request to retrieve data from the backend database.
  ///
  /// [url] is the URL of the API endpoint to retrieve data from.
  /// Example: "http://10.0.2.2:3000/class/"
  static Future<List<ClassModel>> getClassData(String url) async {
    List<ClassModel> classes = [];
    var uri = Uri.parse("${url}viewclass");

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body); // Parse JSON response
        if (data['Data'] != null) {
          classes = (data['Data'] as List)
              .map((value) => ClassModel.fromJson(value))
              .toList();
        }
      } else {
        print("Failed to fetch data: ${res.statusCode}");
        print("Response: ${res.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    return classes;
  }
}
