import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/course_model.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/services/course_api.dart';

final courseListProvider = FutureProvider<List<CourseModel>>((ref) async {
  return await CourseApi.fetchCourses();
});

// Provider for fetching courses by lecturer ID
final courseListByLecturerProvider =
    FutureProvider.family<List<CourseModel>, String>((ref, lecturerId) async {
  return await CourseApi.lectFetchCourses(lecturerId);
});

final courseListStudentProvider =
    FutureProvider.family<List<CourseModel>, String>((ref, studentId) async {
  return await CourseApi.studentFetchCourses(studentId);
});

// Provider for fetching courses by lecturer ID
final courseListByLecturerIdProvider =
    FutureProvider.family<List<CourseModel>, String>((ref, lecturerId) async {
  return await CourseApi.fetchCoursesByLecturerId(lecturerId);
});
