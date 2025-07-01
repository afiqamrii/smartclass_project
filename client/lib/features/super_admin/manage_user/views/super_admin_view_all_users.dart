// Updated Flutter screen for "View All Users" with profile pics, filter chips, role filters, and cleaner layout

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/models/user_models.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/providers/manage_user_provider.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/views/super_admin_view_user_details.dart';

import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class SuperAdminViewAllUsers extends ConsumerStatefulWidget {
  const SuperAdminViewAllUsers({super.key});

  @override
  ConsumerState<SuperAdminViewAllUsers> createState() =>
      _SuperAdminViewAllUsersState();
}

class _SuperAdminViewAllUsersState
    extends ConsumerState<SuperAdminViewAllUsers> {
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
    // ignore: unused_result
    ref.refresh(getAllUserProvider);
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final allUserData = ref.watch(getAllUserProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "View All Users",
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
            size: 20,
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
          children: [
            _buildFilters(context),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: _buildUserList(allUserData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 5,
      ),
      child: Wrap(
        spacing: 5,
        runSpacing: 1,
        children: [
          ..._roleFilters.map((role) => ChoiceChip(
                label: Text(role),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    18.0,
                  ),
                  side: BorderSide(
                    color: Colors.black.withOpacity(
                      0.1,
                    ),
                  ),
                ),
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.4),
                selected: _selectedRoleFilter == role,
                onSelected: (_) => setState(() => _selectedRoleFilter = role),
              )),
        ],
      ),
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

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return ListTile(
              leading: (user.user_picture_url.isNotEmpty)
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.user_picture_url),
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
              title: Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                user.roleName,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              trailing: const Icon(
                Icons.person_outline_rounded,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  toLeftTransition(
                    SuperAdminViewUserDetails(
                      user: user,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      error: (e, st) => const Center(child: Text("Failed to load users")),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
