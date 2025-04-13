import 'package:flutter/material.dart';

class StudentTodayclassCard extends StatefulWidget {
  //Define the properties that the widget needs
  final String className;
  final String courseCode;
  final String classLocation;
  final String date;
  final String timeStart;
  final String timeEnd;
  final String publishStatus;
  final String imageUrl;
  final String lecturerName;

  const StudentTodayclassCard({
    super.key,
    required this.className,
    required this.courseCode,
    required this.classLocation,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    required this.publishStatus,
    required this.imageUrl,
    required this.lecturerName,
  });

  @override
  State<StatefulWidget> createState() => _StudentTodayclassCardState();
}

class _StudentTodayclassCardState extends State<StudentTodayclassCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                SizedBox(
                  height: 200,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Class name
                          Text(
                            widget.className,
                            style: const TextStyle(
                              fontSize: 17,
                              fontFamily: 'Figtree',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.lecturerName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Figtree',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: widget.publishStatus == "Published"
                                  ? Colors.green.withOpacity(1)
                                  : Colors.red.withOpacity(1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.publishStatus == "Published"
                                  ? "Summary Available"
                                  : "Summary Not Available",
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Figtree',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
