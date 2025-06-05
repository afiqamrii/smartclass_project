import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/student/models/check_attendance_models.dart';
import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';
import 'package:smartclass_fyp_2024/features/student/services/classSessionApi.dart';

final todayClassProviders =
    FutureProvider.family<List<TodayclassCardModels> , String>((ref, studentId) async {
  return await Classsessionapi.getClasses(studentId); // Use classProvider from api.dart
});

final upcomingClassProviders =
    FutureProvider.family<List<TodayclassCardModels>, String>((ref , studentId) async {
  return await Classsessionapi
      .getUpcomingClasses(studentId); // Use classProvider from api.dart
});

final pastClassProviders =
    FutureProvider.family<List<TodayclassCardModels>, String>((ref , studentId) async {
  return await Classsessionapi
      .getPastClasses(studentId); // Use classProvider from api.dart
});

//Now class provider
final nowClassProviders =
    FutureProvider.family<List<TodayclassCardModels>, String>(
        (ref, studentId) async {
  return await Classsessionapi.getNowClasses(studentId);
});

//Check attendance
// Provider that takes both classId and studentId as parameters
final checkAttendanceProvider = StreamProvider.family
    .autoDispose<List<CheckAttendanceModel>, (int, String)>((ref, params) async* {
  final (classId, studentId) = params;
  yield* Classsessionapi.checkAttendance(classId, studentId);
});
