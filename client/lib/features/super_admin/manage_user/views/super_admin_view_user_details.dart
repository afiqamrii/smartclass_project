// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/models/user_models.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/providers/manage_user_provider.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/services/manage_user_api.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class SuperAdminViewUserDetails extends ConsumerStatefulWidget {
  const SuperAdminViewUserDetails({super.key, required this.user});
  final UserModels user;

  @override
  ConsumerState<SuperAdminViewUserDetails> createState() =>
      _SuperAdminViewUserDetailsState();
}

class _SuperAdminViewUserDetailsState
    extends ConsumerState<SuperAdminViewUserDetails> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // Function to handle disable user account
  void disableUser(BuildContext context, UserModels user, String status) {
    //Call API to disable user account
    ManageUserApi.disableUserAccount(
      user.userId,
      ref.watch(userProvider).token,
      context,
      user.userEmail,
      status,
    );

    //Force to refresh page
    ref.refresh(getAllUserProvider);
  }

  void _onRefresh() async {
    // ignore: duplicate_ignore
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
    final user = ref.watch(getUserByIdProvider(widget.user.userId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "User Details",
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  widget.user.name[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.user.userEmail,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                widget.user.roleName,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // User Info Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                color: Colors.grey.shade100,
                // elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      _infoRow("Full Name", widget.user.name),
                      _infoRow("Email", widget.user.userEmail),
                      _infoRow("Role", widget.user.roleName),
                      _infoRow("ID", widget.user.externalId),
                      // Add more fields if needed
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Suggested Admin Actions
              _cardSection(context, widget.user),
            ],
          ),
        ),
      ),
    );
  }

  // Card Section
  Widget _cardSection(BuildContext context, UserModels user) {
    return Wrap(
      spacing: 16, // horizontal space between cards
      runSpacing: 16, // vertical space between lines
      children: [
        if (user.status == "Approved")
          _adminCard(
            context,
            label: 'Disable User Account',
            icon: 'assets/icons/disabled.png',
            color: Colors.yellow.shade200,
            onTap: () {
              // Handle disable user account
              disableUser(context, user, "Disabled");
            },
          ),
        if (user.status == "Disabled")
          _adminCard(
            context,
            label: 'Enable User Account',
            icon: 'assets/icons/correct.png',
            color: Colors.green.shade200,
            onTap: () {
              // Handle disable user account
              disableUser(context, user, "Approved");
            },
          ),
        _adminCard(
          context,
          label: 'Delete User Account',
          icon: 'assets/icons/delete.png',
          color: Colors.red.shade300,
          onTap: () {},
        ),
      ],
    );
  }

  // Admin Card Widget
  Widget _adminCard(
    BuildContext context, {
    required String label,
    required String icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.42, // about 42% of screen width
        height: 110,
        // color: color,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    icon,
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
