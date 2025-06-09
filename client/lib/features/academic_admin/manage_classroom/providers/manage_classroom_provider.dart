import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/services/manage_classroom_api.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classroom_models.dart';

final softDeletedClassroomProvider =
    FutureProvider.autoDispose<List<ClassroomModels>>(
  (ref) => ManageClassroomApi.fetchSoftDeletedClassrooms(),
);
