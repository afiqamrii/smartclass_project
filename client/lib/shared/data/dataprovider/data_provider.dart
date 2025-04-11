import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classSum_model.dart';
import 'package:smartclass_fyp_2024/shared/data/models/class_models.dart';
import 'package:smartclass_fyp_2024/shared/data/models/summarization_models.dart';
import 'package:smartclass_fyp_2024/shared/data/services/classApi.dart';
import 'package:smartclass_fyp_2024/shared/data/services/summarizationApi.dart'; // Import the Api class

// Create a Provider Object for class
final classDataProvider = StreamProvider<List<ClassCreateModel>>((ref) async* {
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
