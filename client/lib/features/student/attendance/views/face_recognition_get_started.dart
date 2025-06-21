import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/student/attendance/views/face_recognition_took_pic.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class FaceRecognitionGetStarted extends StatefulWidget {
  final String studentId;
  final int classId;

  const FaceRecognitionGetStarted({
    super.key,
    required this.studentId,
    required this.classId,
  });

  @override
  State<FaceRecognitionGetStarted> createState() =>
      _FaceRecognitionGetStartedState();
}

class _FaceRecognitionGetStartedState extends State<FaceRecognitionGetStarted> {
  Timer? _timer;
  // int _remainingTime = 120; // 2 minutes in seconds
  int _remainingTime = 300; // 3 minutes in seconds

  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _remainingTime;
    _startTimer();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // Starts the countdown timer.
  void _startCountdownTimer() {
    _countdownTimer?.cancel(); // Cancel any existing timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        if (mounted) {
          setState(() {
            _remainingTime--;
          });
        }
      } else {
        timer.cancel();
        // Redirect to the homepage if time runs out by popping both scanner and get started pages
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        if (mounted) {
          setState(() {
            _remainingTime--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  // Formats time to show 'X min' or 'Y s'
  String get _formattedTime {
    // Calculate minutes by dividing total seconds by 60
    final minutes = _remainingTime ~/ 60;

    // Calculate remaining seconds using the modulo operator
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Center(
            child: Text(
              "Remaining: ${_formattedTime}",
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 130.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Lottie.asset(
                  "assets/animations/face_recog_animation.json",
                  height: 200,
                  width: 200,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      Text(
                        "Face Recognition",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "You'll be required to scan your face for 2nd verification. Time will be given for scanning. Please scan between the time provided.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
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
                  // Stop the timer on this page before navigating
                  _timer?.cancel();
                  Navigator.push(
                    context,
                    toLeftTransition(
                      FaceScannerPage(
                        studentId: widget.studentId,
                        classId: widget.classId,
                        // Pass the current remaining time to the next page
                        initialRemainingTime: _remainingTime,
                      ),
                    ),
                  ).then((_) {
                    // This code runs when you return from the scanner page
                    if (mounted) {
                      _startTimer(); // Restart timer if user comes back
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Get Started",
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
