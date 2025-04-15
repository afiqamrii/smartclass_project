import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ClassNowCard extends StatefulWidget {
  //Class Card variable neededdd
  final String className;
  final String courseCode;
  final String classLocation;
  final String timeStart;
  final String timeEnd;
  final String imageUrl;
  final String lecturerName;

  const ClassNowCard({
    super.key,
    required this.className,
    required this.courseCode,
    required this.classLocation,
    required this.timeStart,
    required this.timeEnd,
    required this.imageUrl,
    required this.lecturerName,
  });

  @override
  State<ClassNowCard> createState() => _ClassNowCardState();
}

class _ClassNowCardState extends State<ClassNowCard> {
  late DateTime classStartTime;
  late DateTime classEndTime;
  late Duration remaining;
  Timer? timer;
  bool isLessThan10Minutes = false;

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    final countdownText =
        remaining.isNegative ? "Class Ended" : formatDuration(remaining);

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
              Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
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
                              // Start a timer to close the modal after 1 minutes
                              Timer(const Duration(minutes: 1), () {
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
                                        const Text(
                                          "Ready to Scan",
                                          style: TextStyle(
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
                                          child: const Text(
                                            textAlign: TextAlign.center,
                                            "Hold your device near the NFC reader to clock in attendance.",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Figtree',
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        Lottie.asset(
                                          'assets/animations/nfc.json',
                                          frameRate: FrameRate.max,
                                          width: 250,
                                          fit: BoxFit.cover,
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(modalContext),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30,
                                            ),
                                          ),
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                          ),
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
                          "Tap to Clock In",
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
