import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/models/lecturer/classSum_model.dart';
import 'package:smartclass_fyp_2024/models/lecturer/class_models.dart';
import 'package:smartclass_fyp_2024/models/lecturer/summarization_models.dart';
import 'package:smartclass_fyp_2024/services/lecturer/classApi.dart';
import 'package:smartclass_fyp_2024/services/lecturer/summarizationApi.dart'; // Import the Api class

// Create a Provider Object for class
final classDataProvider = StreamProvider<List<ClassModel>>((ref) async* {
  yield* ref
      .watch(classProvider)
      .getClasses(); // Use classProvider from api.dart
});

// Create a Provider Object for get summarization status for the classes
final classDataProviderSummarizationStatus =
    StreamProvider<List<ClassSumModel>>((ref) async* {
  yield* ref
      .watch(classProviderSummarization)
      .getClassesWithSummarization(); // Use classProvider from api.dart
});

// Create a Provider Object for get summarization
final classDataProviderSummarization =
    StreamProvider.family<List<SummarizationModels>, int>(
        (ref, classId) async* {
  yield* ref
      .watch(classProviderSummarization)
      .getSummarization(classId); // Use classProvider from api.dart
});
