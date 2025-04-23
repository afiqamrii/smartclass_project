import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/student/models/check_attendance_models.dart';
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

//Check attendance
// Provider that takes both classId and studentId as parameters
final checkAttendanceProvider = StreamProvider.family
    .autoDispose<List<CheckAttendanceModel>, (int, String)>((ref, params) async* {
  final (classId, studentId) = params;
  yield* Classsessionapi.checkAttendance(classId, studentId);
});
