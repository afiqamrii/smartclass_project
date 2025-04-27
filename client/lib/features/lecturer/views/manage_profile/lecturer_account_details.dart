import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  @override
  Widget build(BuildContext context) {
    //User data
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: _appBar(user),
      body: _accountDetailsSection(user),
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
                backgroundImage: Image.network(
                        "https://images.unsplash.com/photo-1745555926235-faa237ea89a0?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80")
                    .image,
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
              const LectBottomNavBar(initialIndex: 2),
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
