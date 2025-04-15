import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';

class StudentMyclass extends StatefulWidget {
  const StudentMyclass({super.key});

  @override
  State<StudentMyclass> createState() => _StudentMyclassState();
}

class _StudentMyclassState extends State<StudentMyclass> {
  late DateTime classStartTime;
  late DateTime classEndTime;
  late Duration remaining;
  Timer? timer;
  bool isLessThan10Minutes = false;

  @override
  void initState() {
    super.initState();
    // Default start class time: now
    classStartTime = DateTime.now();
    // Default end class time: 1 hour after start
    classEndTime = classStartTime.add(const Duration(hours: 1));
    remaining = classEndTime.difference(DateTime.now());

    // Start the countdown
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Class"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Card(
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
                    'https://www.cloudblue.com/wp-content/uploads/2024/06/what-is-the-internet-of-things-iot.png',
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
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "CSF3233",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Figtree',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Cyber Security",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'FigtreeRegular',
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "10:00 AM - 11:00 AM",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    "Dr. Nor Azlina | Ibnu Hibban",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
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

                        // Clock-in button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add your clock-in logic here
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
        ),
      ),
    );
  }
}
