import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smartclass_fyp_2024/features/student/views/manage_profile/student_account_details.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/shared/data/services/auth_services.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class StudentEditProfile extends ConsumerStatefulWidget {
  final User user;

  const StudentEditProfile({super.key, required this.user});

  @override
  ConsumerState<StudentEditProfile> createState() => _StudentEditProfileState();
}

class _StudentEditProfileState extends ConsumerState<StudentEditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lecturerIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  //Form key'
  final _formKey = GlobalKey<FormState>();

  //Import AuthServices
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.userName;
    _nameController.text = widget.user.name;
    _lecturerIdController.text = widget.user.externalId;
    _emailController.text = widget.user.userEmail;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _lecturerIdController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  //Update Profile method
  void updateProfile(BuildContext context, WidgetRef ref, int userId) async {
    if (_formKey.currentState!.validate()) {
      // Check if user made any changes
      bool isUsernameChanged =
          _usernameController.text.trim() != widget.user.userName;
      bool isNameChanged = _nameController.text.trim() != widget.user.name;

      if (!isUsernameChanged && !isNameChanged) {
        // No changes detected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No changes were made.'),
            backgroundColor: Colors.orange,
          ),
        );
        return; // Stop the update
      }

      // Prepare fields to update
      String? updatedUsername =
          isUsernameChanged ? _usernameController.text.trim() : null;
      String? updatedName = isNameChanged ? _nameController.text.trim() : null;

      try {
        await Future.any([
          authService.updateUserProfile(
            context: context,
            userId: userId,
            userName: updatedUsername ?? widget.user.userName,
            name: updatedName ?? widget.user.name,
          ),
        ]);

        // You can show a success message after update here if you want
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Get User data
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leadingWidth: 90,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, toRightTransition(const StudentAccountDetails()));
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              ],
            ),
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1745555926235-faa237ea89a0?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -30,
                    child: RawMaterialButton(
                      onPressed: () {},
                      elevation: 2,
                      fillColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black87,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildInputField('Username', _usernameController),
          const SizedBox(height: 16),
          _buildInputField('Name', _nameController),
          const SizedBox(height: 16),
          _buildInputField('Student ID', _lecturerIdController, onTap: () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.info,
              title: 'Info',
              text: 'Student ID cannot be changed.',
              confirmBtnText: 'OK',
            );
          }),
          const SizedBox(height: 16),
          _buildInputField('Email', _emailController, onTap: () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.info,
              title: 'Info',
              text: 'Email cannot be changed.',
              confirmBtnText: 'OK',
            );
          }),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: "Update Profile",
                text: "Are you sure you want to update profile?",
                confirmBtnText: "Yes",
                cancelBtnText: "No",
                onConfirmBtnTap: () async {
                  if (user.userId != null) {
                    updateProfile(context, ref, user.userId!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('User ID is null. Cannot update profile.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              );
              Future.delayed(const Duration(seconds: 5), () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              "Save Changes",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      readOnly: onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
