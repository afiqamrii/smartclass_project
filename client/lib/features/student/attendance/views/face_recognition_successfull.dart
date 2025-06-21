import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/student/views/template/student_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class FaceRecognitionSuccessfull extends ConsumerStatefulWidget {
  const FaceRecognitionSuccessfull({
    super.key,
  });

  @override
  ConsumerState<FaceRecognitionSuccessfull> createState() =>
      _FaceRecognitionSuccessfullState();
}

class _FaceRecognitionSuccessfullState
    extends ConsumerState<FaceRecognitionSuccessfull> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // AppBar _appBar(BuildContext context) {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     elevation: 0,
  //     leading: IconButton(
  //       icon: const Icon(
  //         Icons.arrow_back_ios,
  //         size: 20,
  //         color: Colors.black,
  //       ),
  //       onPressed: () => Navigator.pop(context),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // Get the user data from provider
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Lottie.asset(
                  "assets/animations/face_verified.json",
                  height: 250,
                  width: 250,
                  animate: true,
                  frameRate: FrameRate.max,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    children: [
                      Text(
                        "Congratulations ${user.userName} ! Your attendance has been marked.",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enjoy your class !",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    toRightTransition(
                      const StudentBottomNavbar(
                        initialIndex: 0,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
