import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/student/views/enroll_course/models/enroll_models.dart';
import 'package:smartclass_fyp_2024/features/student/views/enroll_course/services/student_course_enrollment_services.dart';

final enrollmentListProvider =
    FutureProvider.family<List<EnrollModels>, String>((ref, studentId) async {
  return await CourseEnrollmentService.getEnrolledCourses(studentId);
});
