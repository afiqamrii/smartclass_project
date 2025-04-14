import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';
import 'package:smartclass_fyp_2024/features/student/services/classSessionApi.dart';

final todayClassProviders =
    FutureProvider<List<TodayclassCardModels>>((ref) async {
  return await Classsessionapi.getClasses(); // Use classProvider from api.dart
});

final upcomingClassProviders =
    FutureProvider<List<TodayclassCardModels>>((ref) async {
  return await Classsessionapi
      .getUpcomingClasses(); // Use classProvider from api.dart
});

final pastClassProviders =
    FutureProvider<List<TodayclassCardModels>>((ref) async {
  return await Classsessionapi
      .getPastClasses(); // Use classProvider from api.dart
});

//Now class provider
final nowClassProviders =
    StreamProvider<List<TodayclassCardModels>>((ref) async* {
  yield* Classsessionapi.getNowClasses(); // Use classProvider from api.dart
});
