import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/services/manage_course_api.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/course_model.dart';

final softDeletedCoursesProvider =
    FutureProvider.autoDispose<List<CourseModel>>(
  (ref) => ManageCourseApi.fetchSoftDeletedCourses(),
);
