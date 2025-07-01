import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_profile/lecturer_edit_profile.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/template/lecturer_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class LecturerAccountDetails extends ConsumerStatefulWidget {
  const LecturerAccountDetails({super.key});

  @override
  ConsumerState<LecturerAccountDetails> createState() =>
      _LecturerAccountDetailsState();
}

class _LecturerAccountDetailsState
    extends ConsumerState<LecturerAccountDetails> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // ignore: unused_element
  void _onRefresh() async {
    // monitor network fetch
    await ref.read(userProvider.notifier).refreshUserData();
    await Future.delayed(const Duration(seconds: 1));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(seconds: 1));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    //User data
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: _appBar(user),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const ClassicHeader(
          releaseIcon: Icon(
            Icons.arrow_upward,
            color: Colors.grey,
          ),
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          children: [
            _accountDetailsSection(user),
          ],
        ),
      ),
    );
  }

  Widget _accountDetailsSection(User user) {
    return Column(
      children: [
        const SizedBox(height: 10),
        //Profile section
        SizedBox(
          height: 90,
          width: 90,
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: user.user_picture_url.isNotEmpty
                    ? NetworkImage(user.user_picture_url)
                    : const AssetImage(
                        'assets/pictures/compPicture.jpg',
                      ) as ImageProvider,
              ),
            ],
          ),
        ),
        //User information section
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _classDetails("Username", user.userName),
                    const SizedBox(height: 10),
                    //Make a horizontal line here
                    Divider(
                      color: Colors.black.withOpacity(0.1),
                      thickness: 0.5,
                    ),
                    //
                    const SizedBox(height: 10),
                    //Name Section
                    _classDetails("Full Name", user.name),
                    const SizedBox(height: 10),
                    //Make a horizontal line here
                    Divider(
                      color: Colors.black.withOpacity(0.1),
                      thickness: 0.5,
                    ),
                    //User External ID Section
                    const SizedBox(height: 10),
                    _classDetails("Lecture ID", user.externalId),
                    const SizedBox(height: 10),
                    //Make a horizontal line here
                    Divider(
                      color: Colors.black.withOpacity(0.1),
                      thickness: 0.5,
                    ),
                    //User Email Section
                    const SizedBox(height: 10),
                    _classDetails("Email", user.userEmail),
                    const SizedBox(height: 10),
                    //Make a horizontal line here
                    Divider(
                      color: Colors.black.withOpacity(0.1),
                      thickness: 0.5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _classDetails(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Username section here
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[600],
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  AppBar _appBar(User user) {
    return AppBar(
      title: const Text(
        "Account Details",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xffF5F5F5),
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            toRightTransition(
              const LectBottomNavBar(initialIndex: 1),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                toLeftTransition(
                  LecturerEditProfile(
                    user: user,
                  ),
                ),
              );
            },
            child: Text(
              "Edit",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
