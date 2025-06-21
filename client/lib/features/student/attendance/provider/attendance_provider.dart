import 'package:flutter_riverpod/flutter_riverpod.dart';

final attendanceStatusProvider = StateProvider.family<bool, int>((ref, classId) => false);