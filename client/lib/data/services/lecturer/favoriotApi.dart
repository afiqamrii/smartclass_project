import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';

class FavoriotApi {
  //Based url for WIFI Rumah
  // static const baseUrl = "http://192.168.0.99:3000/mqtt/";

  // //Based url for HOSTPOT MyPhone
  // static const baseUrl = "http://172.20.10.2:3000/mqtt/";

  // Publish data to Favoriot MQTT broker.
  static Future<void> publishData(String command, int classId) async {
    // Endpoint
    var url = Uri.parse("${ApiConstants.baseUrl}/mqtt/send-command/$classId");
    final body = jsonEncode({"command": command, "classId": classId});

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to publish data: ${res.statusCode}");
    }
  }
}
