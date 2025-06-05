import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:smartclass_fyp_2024/features/lecturer/manage_attendance/views/lecturer_view_attendance.dart';
import 'package:smartclass_fyp_2024/features/student/providers/student_class_provider.dart';
import 'package:smartclass_fyp_2024/nfc/start_clock_in_nfc.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class LecturerClassNowCard extends ConsumerStatefulWidget {
  //Class Card variable neededdd
  final int classId;
  final String userId;
  final String className;
  final String courseCode;
  final String classLocation;
  final String timeStart;
  final String timeEnd;
  final String imageUrl;
  final String lecturerName;

  const LecturerClassNowCard({
    super.key,
    required this.classId,
    required this.userId,
    required this.className,
    required this.courseCode,
    required this.classLocation,
    required this.timeStart,
    required this.timeEnd,
    required this.imageUrl,
    required this.lecturerName,
  });

  @override
  ConsumerState<LecturerClassNowCard> createState() =>
      _LecturerClassNowCardState();
}

class _LecturerClassNowCardState extends ConsumerState<LecturerClassNowCard> {
  late DateTime classStartTime;
  late DateTime classEndTime;
  late Duration remaining;
  Timer? timer;
  bool isLessThan10Minutes = false;
  String currentAnimation = 'assets/animations/nfc.json';
  bool isAlreadyClockIn = false;
  bool isTimeout = false;
  bool isGracePeriod = false;

  late DateTime classEndGraceTime;

  @override
  void initState() {
    super.initState();

    // ⬇️ Initialize NFC
    NfcClockInService.initNfc();

    //Check if nfc is enabled or not

    final now = DateTime.now();
    final timeFormat = DateFormat
        .jm(); // Parses time from model which is "10:00 AM", "3:45 PM"

    // Parse start and end times using intl
    final parsedStartTime = timeFormat.parse(widget.timeStart);
    final parsedEndTime = timeFormat.parse(widget.timeEnd);

    classStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsedStartTime.hour,
      parsedStartTime.minute,
    );

    classEndTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsedEndTime.hour,
      parsedEndTime.minute,
    );

    // Handle classes that end past midnight
    if (classEndTime.isBefore(classStartTime)) {
      classEndTime = classEndTime.add(const Duration(days: 1));
    }

    remaining = classEndTime.difference(DateTime.now());

    // Add 1 hour grace period after class ends
    classEndGraceTime = classEndTime.add(const Duration(hours: 1));

    // Start countdown
    timer =
        Timer.periodic(const Duration(seconds: 1), (_) => updateCountdown());
  }

  void updateCountdown() {
    final now = DateTime.now();
    setState(() {
      remaining = classEndTime.difference(now);

      isLessThan10Minutes = remaining.inMinutes < 10;

      if (now.isAfter(classEndTime) && now.isBefore(classEndGraceTime)) {
        isGracePeriod = true;
      } else if (now.isAfter(classEndGraceTime)) {
        timer?.cancel();
        isTimeout = true;
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  // ignore: unused_field
  bool _isRefreshing = false; // Add loading state

// Handle the refresh and reload data from provider
  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() {
      _isRefreshing = true;
    });

    // await ref.read(nowClassProviders);
    await ref.read(userProvider.notifier).refreshUserData();
    await Future.delayed(const Duration(seconds: 10));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the user data from provider
    // ignore: unused_local_variable
    final user = ref.watch(userProvider);

    ref.listen(
      checkAttendanceProvider((widget.classId, widget.userId)),
      (previous, next) {
        next.whenData((attendanceList) {
          final status = attendanceList.first.attendanceStatus;
          if (status == "Present" &&
              currentAnimation != 'assets/animations/animation_success.json') {
            setState(() {
              currentAnimation = 'assets/animations/animation_success.json';
              isAlreadyClockIn = true;
            });

            Flushbar(
              message:
                  'Congrats ${user.userName}! Your attendance recorded successfully!',
              duration: const Duration(seconds: 10),
              backgroundColor: Colors.green.shade600,
              margin: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              flushbarPosition: FlushbarPosition.TOP,
              icon: const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
            ).show(context);

            // ✅ Close bottom sheet after short delay (e.g., 2 seconds)
            Future.delayed(const Duration(seconds: 2), () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
          }
        });
      },
    );

    // ignore: unused_local_variable
    final checkAttendance =
        ref.watch(checkAttendanceProvider((widget.classId, widget.userId)));

    //Show countdown as 00 if the countdown is end
    final countdownText =
        remaining.isNegative ? "00:00:00" : formatDuration(remaining);

    //Show class ended
    if (isTimeout) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.access_time_outlined,
              color: Colors.redAccent,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              'Class has ended!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 5,
      color: const Color.fromARGB(255, 255, 249, 249),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: IntrinsicHeight(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SizedBox(
                height: 200,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) {
                    return Image.asset(
                      'assets/pictures/compPicture.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Positioned(
                top: 1,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.black.withOpacity(0.95),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(17.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Class Info & Timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Class Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.courseCode,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Figtree',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                widget.className,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'FigtreeRegular',
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "${widget.timeStart} - ${widget.timeEnd}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                "${widget.lecturerName} | ${widget.classLocation}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "You may review attendance within the remaining time with one more hour after the class ends.",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'FigtreeRegular',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // const SizedBox(width: 10),

                        // Countdown timer
                        if (!isGracePeriod)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              countdownText.split(":").length,
                              (index) {
                                final time = countdownText.split(":")[index];
                                final labels = ['Hr', 'Min', 'Sec'];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.5),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 26,
                                        height: 26,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isLessThan10Minutes
                                              ? Colors.red
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 3,
                                              offset: Offset(0, 1.5),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          time,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Figtree',
                                            color: isLessThan10Minutes
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        labels[index],
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontFamily: 'FigtreeRegular',
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // See attendance button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          //Handle see attendance here
                          Navigator.of(context).push(
                            toLeftTransition(
                              LecturerViewAttendance(
                                classId: widget.classId,
                              ),
                            ),
                          );
                        },
                        icon: Image.asset(
                          'assets/icons/attendance.png',
                          width: 17,
                          height: 17,
                        ),
                        label: const Text(
                          "View Student Attendance",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Figtree',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
