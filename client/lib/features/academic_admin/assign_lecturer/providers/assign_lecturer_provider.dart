import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/models/user_models.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/assign_lecturer/services/assign_lecturer_api.dart';

// assignLecturerProvider is used to fetch all lecturers available for assignment
final assignLecturerProvider = FutureProvider.autoDispose.family<List<UserModels>, int>((ref, courseId) async {
  return await AssignLecturerApi.fetchLecturers(courseId);
});

//Get assigned lecturers for a specific course
final assignedLecturersProvider = FutureProvider.autoDispose.family<List<UserModels>, int>((ref, courseId) async {
  return await AssignLecturerApi.fetchAssignedLecturers(courseId);
});