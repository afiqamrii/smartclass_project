// View All Pending Approval Users with Approve & Reject Actions
// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/models/user_models.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/providers/manage_user_provider.dart';
import 'package:smartclass_fyp_2024/features/super_admin/pending_approval/services/pending_approval_api.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class SuperAdminViewPendingApproval extends ConsumerStatefulWidget {
  const SuperAdminViewPendingApproval({super.key});

  @override
  ConsumerState<SuperAdminViewPendingApproval> createState() =>
      _SuperAdminViewPendingApprovalState();
}

class _SuperAdminViewPendingApprovalState
    extends ConsumerState<SuperAdminViewPendingApproval> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String _selectedRoleFilter = "All";

  final List<String> _roleFilters = [
    "All",
    "Student",
    "Lecturer",
    "PPH Staff",
    "Academic Admin",
  ];

  void _onRefresh() async {
    ref.refresh(getAllPendingApprovalProvider);
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.loadComplete();
  }

  Future<void> _approveUser(UserModels user, BuildContext context) async {
    //Call API to approve user
    await PendingApprovalApi.approveUser(
      user.userId,
      ref.watch(userProvider).token,
      context,
      "Approved",
      user.userEmail,
    );

    //Force to refresh
    ref.refresh(getAllPendingApprovalProvider);
  }

  Future<void> _rejectUser(UserModels user, BuildContext context) async {
    //Call API to approve user
    await PendingApprovalApi.approveUser(
      user.userId,
      ref.watch(userProvider).token,
      context,
      "Rejected",
      user.userEmail,
    );

    //Force to refresh
    ref.refresh(getAllPendingApprovalProvider);
  }

  @override
  Widget build(BuildContext context) {
    final allUserData = ref.watch(getAllPendingApprovalProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: const Text(
          "Pending Approvals",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const ClassicHeader(),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            _buildFilters(context),
            const SizedBox(height: 10),
            _buildUserList(allUserData),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: _roleFilters.map((role) {
        return ChoiceChip(
          label: Text(role),
          labelStyle: const TextStyle(fontSize: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          selectedColor: Theme.of(context).primaryColor.withOpacity(0.4),
          selected: _selectedRoleFilter == role,
          onSelected: (_) => setState(() => _selectedRoleFilter = role),
        );
      }).toList(),
    );
  }

  Widget _buildUserList(AsyncValue<List<UserModels>> allUserData) {
    return allUserData.when(
      data: (data) {
        final filteredUsers = data.where((user) {
          if (_selectedRoleFilter != "All" &&
              user.roleName != _selectedRoleFilter) {
            return false;
          }
          return true;
        }).toList();

        if (filteredUsers.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("No users to approve."),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      (user.user_picture_url.isNotEmpty)
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(user.user_picture_url),
                            )
                          : CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.grey.shade300,
                              child: Text(
                                user.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  user.roleName,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.userEmail,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.externalId,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: 'Confirm Approval',
                            text:
                                'Are you sure you want to reject this user? This action cannot be undone.',
                            confirmBtnText: 'Reject',
                            cancelBtnText: 'Cancel',
                            onConfirmBtnTap: () => _rejectUser(user, context),
                            onCancelBtnTap: () => Navigator.pop(context),
                          );
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 18,
                        ),
                        label: const Text(
                          "Reject",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: 'Confirm Approval',
                            text: 'Are you sure you want to approve this user?',
                            confirmBtnText: 'Approve',
                            cancelBtnText: 'Cancel',
                            onConfirmBtnTap: () => _approveUser(user, context),
                            onCancelBtnTap: () => Navigator.pop(context),
                          );
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          "Approve",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // const Divider(
                  //   thickness: 0.5,
                  //   color: Colors.grey,
                  // ),
                ],
              ),
            );
          },
        );
      },
      error: (e, st) => const Center(child: Text("Failed to load users")),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
