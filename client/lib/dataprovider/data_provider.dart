import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/models/class_models.dart';
import 'package:smartclass_fyp_2024/services/api.dart'; // Import the Api class

final classDataProvider = FutureProvider<List<ClassModel>>((ref) async {
  return ref
      .watch(classProvider)
      .getClasses(); // Use classProvider from api.dart
});
