import 'dart:isolate';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/shared/WebSocket/provider/socket_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:smartclass_fyp_2024/features/student/providers/student_class_provider.dart';
import 'package:smartclass_fyp_2024/features/student/testImageRecog.dart';
import 'package:smartclass_fyp_2024/nfc/start_clock_in_nfc.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class ClassNowCard extends ConsumerStatefulWidget {
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

  const ClassNowCard({
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
  ConsumerState<ClassNowCard> createState() => _ClassNowCardState();
}

class _ClassNowCardState extends ConsumerState<ClassNowCard> {
  late DateTime classStartTime;
  late DateTime classEndTime;
  late Duration remaining;
  Timer? timer;
  bool isLessThan10Minutes = false;
  String currentAnimation = 'assets/animations/nfc.json';
  bool isAlreadyClockIn = false;
  bool isTimeout = false;
  late IO.Socket socket;

  //Get nfcclockin.isClockIn bool value
  final ValueNotifier<bool> isClockIn = NfcClockInService.isClockingIn;

  @override
  void initState() {
    super.initState();

    // Initialize Socket
    Future.microtask(() => _setupSocket());

    // Initialize NFC
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

    // Start countdown
    timer =
        Timer.periodic(const Duration(seconds: 1), (_) => updateCountdown());
  }

  void updateCountdown() {
    final now = DateTime.now();
    setState(() {
      remaining = classEndTime.difference(now);

      // Dynamically update the isLessThan10Minutes flag
      isLessThan10Minutes = remaining.inMinutes < 10;

      if (remaining.isNegative) {
        timer?.cancel();
        // Trigger a refresh of the provider here
        isTimeout = true;
      }
    });
  }

  void _setupSocket() {
    final user = ref.read(userProvider);
    final socketService = ref.read(socketServiceProvider.notifier);
    socketService.init(user.externalId);

    socket = ref.read(socketServiceProvider)!;

    // Remove any old listeners
    socket.off('pending_face_verification'); // Clean up first

    // Listen for

    socket.on('pending_face_verification', (data) {
      if (!mounted) return;
      // Handle the pending face verification event
      //Redirect to face verification page
      Navigator.push(
        context,
        toLeftTransition(
          FaceScannerPage(
            studentId: widget.userId,
            classId: widget.classId,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    socket.off('pending_face_verification');
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

    // ref.listen(
    //   checkAttendanceProvider((widget.classId, widget.userId)),
    //   (previous, next) {
    //     next.whenData((attendanceList) {
    //       final status = attendanceList.first.attendanceStatus;
    //       if (status == "Pending Face Verifications") {
    //         Navigator.push(
    //           context,
    //           toLeftTransition(
    //             FaceScannerPage(
    //               studentId: widget.userId,
    //               classId: widget.classId,
    //             ),
    //           ),
    //         );
    //       }
    //     });
    //   },
    // );

    // ref.listen(
    //   checkAttendanceProvider((widget.classId, widget.userId)),
    //   (previous, next) {
    //     next.whenData((attendanceList) {
    //       final status = attendanceList.first.attendanceStatus;
    //       if (status == "Present" &&
    //           currentAnimation != 'assets/animations/animation_success.json') {
    //         setState(() {
    //           currentAnimation = 'assets/animations/animation_success.json';
    //           isAlreadyClockIn = true;
    //         });

    //         Flushbar(
    //           message:
    //               'Congrats ${user.userName}! Your attendance recorded successfully!',
    //           duration: const Duration(seconds: 10),
    //           backgroundColor: Colors.green.shade600,
    //           margin: const EdgeInsets.all(8),
    //           borderRadius: BorderRadius.circular(8),
    //           flushbarPosition: FlushbarPosition.TOP,
    //           icon: const Icon(
    //             Icons.check_circle,
    //             color: Colors.white,
    //           ),
    //         ).show(context);

    //         // Close bottom sheet after short delay (e.g., 2 seconds)
    //         Future.delayed(const Duration(seconds: 2), () {
    //           if (Navigator.of(context).canPop()) {
    //             Navigator.of(context).pop();
    //           }
    //         });
    //       }
    //     });
    //   },
    // );

    // ignore: unused_local_variable
    final checkAttendance =
        ref.watch(checkAttendanceProvider((widget.classId, widget.userId)));

    final countdownText =
        remaining.isNegative ? "Class Ended" : formatDuration(remaining);

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
                                "Scan attendance within the remaining time only.",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'FigtreeRegular',
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // const SizedBox(width: 10),

                        // Countdown timer
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            countdownText.split(":").length,
                            (index) {
                              final time = countdownText.split(":")[index];
                              final labels = ['Hr', 'Min', 'Sec'];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.5),
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
                                        borderRadius: BorderRadius.circular(6),
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

                    // Clock-in button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            barrierColor: Colors.black54,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            context: context,
                            builder: (modalContext) {
                              // 🔄 Start NFC Clock-In when modal shows
                              NfcClockInService.startClockIn(
                                studentId: widget
                                    .userId, // you can replace this with a dynamic value
                                courseCode: widget.courseCode,
                                classId: widget.classId.toString(),
                                // or use an actual classId if available
                              );
                              // Start a timer to close the modal after 1 minutes
                              Timer(const Duration(minutes: 5), () {
                                NfcClockInService
                                    .stopClockIn(); //  Stop NFC on timeout
                                if (Navigator.of(modalContext).canPop()) {
                                  Navigator.of(modalContext).pop();
                                }
                              });

                              return IntrinsicHeight(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.46,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 25,
                                      right: 25,
                                      top: 15,
                                      bottom: 5,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          isAlreadyClockIn
                                              ? "Already Clock In !"
                                              : "Ready to Scan",
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'Figtree',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            isAlreadyClockIn
                                                ? "You have already clocked in for today class."
                                                : "Hold your device near the NFC reader to clock in attendance.",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Figtree',
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        ValueListenableBuilder<bool>(
                                          valueListenable:
                                              NfcClockInService.isClockingIn,
                                          builder: (context, isSending, child) {
                                            return Lottie.asset(
                                              isSending
                                                  ? 'assets/animations/attendanceLoading.json'
                                                  : currentAnimation,
                                              width: 190,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                        if (!isAlreadyClockIn)
                                          ValueListenableBuilder(
                                            valueListenable:
                                                NfcClockInService.isClockingIn,
                                            builder:
                                                (context, isSending, child) {
                                              return Text(
                                                isSending
                                                    ? "Waiting Server to responds..."
                                                    : "",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Figtree',
                                                  color: Colors.black54,
                                                ),
                                              );
                                            },
                                          ),
                                        if (!isAlreadyClockIn)
                                          ValueListenableBuilder<bool>(
                                            valueListenable:
                                                NfcClockInService.isClockingIn,
                                            builder:
                                                (context, isSending, child) {
                                              // Show the cancel button only when NOT clocking in
                                              return isSending
                                                  ? const SizedBox.shrink()
                                                  : ElevatedButton(
                                                      onPressed: () {
                                                        NfcClockInService
                                                            .stopClockIn();
                                                        Navigator.pop(
                                                          modalContext,
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        foregroundColor:
                                                            Colors.black,
                                                        elevation: 2,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: 12,
                                                          horizontal:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.30,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                      ),
                                                    );
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/fingerprint.svg',
                          width: 15,
                          height: 15,
                        ),
                        label: const Text(
                          "Tap to Clock In ",
                          style: TextStyle(
                            fontSize: 13,
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
