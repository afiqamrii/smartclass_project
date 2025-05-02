import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/course_model.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/services/course_api.dart';

final courseListProvider = FutureProvider<List<CourseModel>>((ref) async {
  return await CourseApi.fetchCourses();
});
