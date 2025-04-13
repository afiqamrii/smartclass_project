import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';
import 'package:smartclass_fyp_2024/features/student/services/classSessionApi.dart';

final todayClassProviders =
    FutureProvider<List<TodayclassCardModels>>((ref) async {
  return await Classsessionapi.getClasses(); // Use classProvider from api.dart
});
