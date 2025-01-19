import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/models/lecturer/classSum_model.dart';
import 'package:smartclass_fyp_2024/models/lecturer/class_models.dart';
import 'package:smartclass_fyp_2024/models/lecturer/summarization_models.dart';
import 'package:smartclass_fyp_2024/services/lecturer/classApi.dart';
import 'package:smartclass_fyp_2024/services/lecturer/summarizationApi.dart'; // Import the Api class

// Create a Provider Object for class
final classDataProvider = FutureProvider<List<ClassModel>>((ref) async {
  return ref
      .watch(classProvider)
      .getClasses(); // Use classProvider from api.dart
});

// Create a Provider Object for get summarization status for the classes
final classDataProviderSummarizationStatus =
    FutureProvider<List<ClassSumModel>>((ref) async {
  return ref
      .watch(classProvider)
      .getClassesWithSummarization(); // Use classProvider from api.dart
});

// Create a Provider Object for get summarization
final classDataProviderSummarization =
    FutureProvider.family<List<SummarizationModels>, int>((ref, classId) async {
  return ref
      .watch(classProviderSummarization)
      .getSummarization(classId); // Use classProvider from api.dart
});
