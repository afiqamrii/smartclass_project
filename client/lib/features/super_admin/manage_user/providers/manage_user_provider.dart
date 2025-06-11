import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/models/user_models.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/services/manage_user_api.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';


//Get all users
final getAllUserProvider = FutureProvider<List<UserModels>>((ref) async {
  final token = ref.watch(userProvider).token;
  return await ManageUserApi.fetchUsers(token);
});

//Get all pending approval
final getAllPendingApprovalProvider = FutureProvider<List<UserModels>>((ref) async {
  final token = ref.watch(userProvider).token;
  return await ManageUserApi.fetchPendingApproval(token);
});

