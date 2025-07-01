import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_summarization/models/summary_prompt_models.dart';
import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classSum_model.dart';
import 'package:smartclass_fyp_2024/shared/data/models/class_models.dart';
import 'package:smartclass_fyp_2024/shared/data/models/summarization_models.dart';
import 'package:smartclass_fyp_2024/shared/data/services/classApi.dart';
import 'package:smartclass_fyp_2024/shared/data/services/summarizationApi.dart'; // Import the Api class

// Create a Provider Object for class
final classDataProvider = FutureProvider.family<List<ClassCreateModel>, String>(
    (ref, lecturerId) async {
  return await ref.watch(classProvider).getClasses(lecturerId);
});

final classByIdProvider =
    FutureProvider.family<List<ClassCreateModel>, int>((ref, classId) async {
  return await ref.watch(classProvider).getClassById(classId);
});

// Create a Provider Object for get summarization status for the classes
final classDataProviderSummarizationStatus =
    StreamProvider.family<List<ClassSumModel>, String>(
        (ref, lecturerId) async* {
  yield* ref.watch(classProviderSummarization).getClassesWithSummarization(
      lecturerId); // Use classProvider from api.dart
});

// Create a Provider Object for get summarization
final classDataProviderSummarization =
    StreamProvider.family<List<SummarizationModels>, int>(
        (ref, classId) async* {
  yield* ref
      .watch(classProviderSummarization)
      .getSummarization(classId); // Use classProvider from api.dart
});

//Lecturer get Now class provider
final nowClassProviders =
    FutureProvider.family<List<TodayclassCardModels>, String>(
        (ref, lecturerId) async {
  return await Api.getNowClasses(lecturerId);
});

//Student get summarization
final studentSummarizationProvider =
    StreamProvider.family<List<SummarizationModels>, int>(
        (ref, classId) async* {
  yield* ref
      .watch(classProviderSummarization)
      .getStudentSummarization(classId); // Use classProvider from api.dart
});

final savedPromptsProvider =
    FutureProvider<List<SummaryPromptModels>>((ref) async {
  final lecturerId = ref.watch(userProvider).externalId;
  return await Summarizationapi.getSavedPrompts(lecturerId);
  
});
