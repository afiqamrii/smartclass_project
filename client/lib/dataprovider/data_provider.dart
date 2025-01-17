import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/models/lecturer/class_models.dart';
import 'package:smartclass_fyp_2024/models/lecturer/summarization_models.dart';
import 'package:smartclass_fyp_2024/services/lecturer/classApi.dart';
import 'package:smartclass_fyp_2024/services/lecturer/summarizationApi.dart'; // Import the Api class

final classDataProvider = FutureProvider<List<ClassModel>>((ref) async {
  return ref
      .watch(classProvider)
      .getClasses(); // Use classProvider from api.dart
});

final classDataProviderSummarization =
    FutureProvider.family<List<SummarizationModels>, int>((ref,classId) async {
  return ref
      .watch(classProviderSummarization)
      .getSummarization(classId); // Use classProvider from api.dart
});
