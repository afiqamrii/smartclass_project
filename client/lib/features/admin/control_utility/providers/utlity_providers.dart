import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/models/utility_models.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/services/utility_service.dart';

class UtilityNotifier extends StateNotifier<List<UtilityModels>> {
  UtilityNotifier() : super([]);

  // Fetch and initialize utilities
  Future<void> loadUtilities(int classroomId) async {
    state = []; // ✅ Clear previous state to avoid stale data
    try {
      final utilities = await UtilityService.fetchUtility(classroomId);
      state = utilities;
    } catch (e) {
      print("Error loading utilities: $e");
      state = []; // Optional: ensure state is empty on failure
    }
  }

  // Update a specific utility (e.g. when socket emits a change)
  void updateUtility(UtilityModels updated) {
    state = [
      for (final utility in state)
        if (utility.utilityId == updated.utilityId) updated else utility
    ];
  }

  void updateUtilityStatusByClassroomId(
      {required int classroomId, required String newStatus}) {
    state = [
      for (final utility in state)
        if (utility.classroomId == classroomId)
          utility.copyWith(utilityStatus: newStatus)
        else
          utility
    ];
  }
}

final utilityProvider =
    StateNotifierProvider<UtilityNotifier, List<UtilityModels>>(
  (ref) => UtilityNotifier(),
);
