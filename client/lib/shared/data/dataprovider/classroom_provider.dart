import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartclass_fyp_2024/shared/data/models/classroom_models.dart';
import 'package:smartclass_fyp_2024/shared/data/services/classroom_api.dart';

final classroomApiProvider = FutureProvider<List<ClassroomModels>>((ref) async {
  return await ClassroomApi.fetchClassrooms();
});
