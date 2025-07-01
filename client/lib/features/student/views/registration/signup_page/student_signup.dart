import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/student/views/registration/signup_page/face_register_page.dart';
import 'package:smartclass_fyp_2024/shared/components/confirmPassword_textfield.dart';
import 'package:smartclass_fyp_2024/shared/components/login_textfield.dart';
import 'package:smartclass_fyp_2024/shared/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/shared/components/password_textfield.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/role.dart';
import 'package:smartclass_fyp_2024/shared/widgets/appbar.dart';

import '../../../../../shared/data/services/auth_services.dart';

class StudentSignupPage extends ConsumerWidget {
  StudentSignupPage({super.key});

  //Import AuthServices
  final authService = AuthService();

  //Text editing controller
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final name = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final studentIdController = TextEditingController();

  //Sign user in method
  void signUserIn(BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).state = true; //Start loading
    final faceImage = ref.read(faceImageProvider); // get image
    if (faceImage == null) {
      // Show error if no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture your face image first.')),
      );
      ref.read(loadingProvider.notifier).state = false; //Stop loading
      return;
    }
    // Check if all fields are filled
    if (userNameController.text.isEmpty ||
        name.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        studentIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      ref.read(loadingProvider.notifier).state = false; //Stop loading
      return;
    }

    await authService.signUpUserWithFace(
      context: context,
      ref: ref,
      userName: userNameController.text,
      name: name.text,
      userEmail: emailController.text,
      userPassword: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      roleId: Role.student, //Set roleId to 1 (Student)
      externalId: studentIdController.text, //Set externalId to
      imageFile: faceImage, //Pass the captured face image
    );

    ref.read(loadingProvider.notifier).state = false; //Stop loading
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    final faceImage = ref.watch(faceImageProvider); // watch image for preview

    return Scaffold(
      appBar: const Appbar(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.01,
              right: screenWidth * 0.01,
              bottom: screenWidth * 0.15,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Hey, Student. \nLet's sign you in.",
                        style: TextStyle(
                          fontSize: 27,
                          fontFamily: 'FigtreeExtraBold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                //Username textfield
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                // username textfield
                MyLoginTextField(
                  controller: userNameController,
                  hintText: 'alibinabu123',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                //Name textfield
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                //Name textfield
                MyLoginTextField(
                  controller: name,
                  hintText: 'Ahmad Ali',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                //User ID textfield
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Student ID',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                //Username textfield
                MyLoginTextField(
                  controller: studentIdController,
                  hintText: 'S12345',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                //Email title
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                //Email textfield
                MyLoginTextField(
                  controller: emailController,
                  hintText: 'alibinabu@gmail.com',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                //Password title
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                //Password textfield
                PasswordTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  isPasswordForm: true,
                  isSignUpForm: true,
                  password: passwordController.text,
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                //Confirm Password title
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                //Confirm Password textfield
                ConfirmPasswordTextfield(
                  controller: confirmPasswordController,
                  passwordController: passwordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 15),
                if (faceImage == null)
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Register your face',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 5),

                // Preview section
                if (faceImage == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.face_retouching_natural,
                                  size: 45,
                                  color: ColorConstants.primaryColor,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Register Your Face",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Please scan your face clearly in a well-lit area.\n"
                                  "This photo will be saved for attendance verification.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 15,
                                  ),
                                  label: const Text(
                                    "Scan Face",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorConstants.backgroundColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final capturedFile = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FaceRegisterPage(),
                                      ),
                                    );

                                    if (capturedFile != null) {
                                      ref
                                          .read(faceImageProvider.notifier)
                                          .state = capturedFile;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                const SizedBox(height: 15),
                // Preview section
                if (faceImage != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Preview of Captured Face",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: Image.file(
                                faceImage,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "This image will be used for attendance verification.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "If you want to change the image, please click on the 'Scan Face' button again.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Note: Please ensure the image is clear and well-lit.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        //Button to retake face image
                        ElevatedButton.icon(
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 15,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Retake Face Image",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.backgroundColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () async {
                              final capturedFile = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const FaceRegisterPage(),
                                ),
                              );

                              if (capturedFile != null) {
                                ref.read(faceImageProvider.notifier).state =
                                    capturedFile;
                              }
                            }),
                      ],
                    ),
                  ),

                const SizedBox(height: 30),

                //Login button
                CustomButton(
                  text: 'Create Account',
                  isLoading: ref.watch(loadingProvider), //Get loading state
                  onTap: () {
                    signUserIn(context, ref);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leadingWidth: 100,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
              Text(
                "Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
