import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/course_enrollment/models/course_enrollment_request_model.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/course_enrollment/services/course_enrollment_request_api.dart';

class EnrollmentRequestArgs {
  final String lecturerId;
  final int courseId;

  const EnrollmentRequestArgs(this.lecturerId, this.courseId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnrollmentRequestArgs &&
          runtimeType == other.runtimeType &&
          lecturerId == other.lecturerId &&
          courseId == other.courseId;

  @override
  int get hashCode => lecturerId.hashCode ^ courseId.hashCode;
}

final enrollmentRequestListProvider = FutureProvider.family
    .autoDispose<List<CourseEnrollmentRequest>, EnrollmentRequestArgs>(
  (ref, args) async {
    // Keep this provider alive as long as possible
    ref.keepAlive();
    return await CourseEnrollmentRequestApi.getEnrolledRequests(
      args.lecturerId,
      args.courseId,
    );
  },
);
