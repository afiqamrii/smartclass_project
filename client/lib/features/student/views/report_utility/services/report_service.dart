import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart'; // For detecting mime type
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'package:flutter/material.dart';

Future<void> submitReports(BuildContext context, String title,
    String description, File? selectedImage) async {
  if (title.isEmpty || description.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Title and Description are required")),
    );
    return;
  }

  if (selectedImage != null) {
    // Send the title, description, and image to your backend
    final uri = Uri.parse("https://your-api-url.com/report");
    final request = http.MultipartRequest("POST", uri)
      ..fields['title'] = title
      ..fields['description'] = description;

    // Add the image file to the request
    var fileBytes = await selectedImage.readAsBytes();
    String mimeType = lookupMimeType(selectedImage.path) ?? 'image/jpeg';
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: 'report_image.jpg', // Provide a filename
      contentType: MediaType.parse(mimeType),
    ));

    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report submitted successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit report")),
      );
    }
  } else {
    // If no image selected, submit just the title and description
    final uri = Uri.parse("https://your-api-url.com/report");
    final response = await http.post(
      uri,
      body: {
        'title': title,
        'description': description,
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report submitted successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit report")),
      );
    }
  }
}
