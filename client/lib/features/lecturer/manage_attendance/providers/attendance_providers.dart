import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/lecturer/manage_attendance/models/attendance_models.dart';
import 'package:smartclass_fyp_2024/features/lecturer/manage_attendance/services/attendance_services.dart';


final attendanceProvider = FutureProvider.family<List<AttendanceReport>, int>((ref, classId) async {
  return AttendanceService().fetchAttendanceReport(classId);
});