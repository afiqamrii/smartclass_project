import 'dart:convert';

import 'package:flutter/services.dart';

class AppStrings {
  static Map<String, dynamic> _localizedStrings = {};

  static Future<void> loadStrings() async {
    String jsonString = await rootBundle.loadString('lib/master/strings.json');
    _localizedStrings = json.decode(jsonString);
    print(_localizedStrings); // Debugging
  }

  static String get(String group, String key) {
    print('Fetching: $group.$key'); // Debugging
    return _localizedStrings[group]?[key] ?? '**$group.$key**';
  }
}
