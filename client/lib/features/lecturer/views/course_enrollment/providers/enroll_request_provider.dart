import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/course_enrollment/models/course_enrollment_request_model.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/course_enrollment/services/course_enrollment_request_api.dart';

final enrollmentRequestListProvider =
    FutureProvider.family<List<CourseEnrollmentRequest>, String>(
        (ref, lecturerId) async {
  return await CourseEnrollmentRequestApi.getEnrolledRequests(lecturerId);
});
