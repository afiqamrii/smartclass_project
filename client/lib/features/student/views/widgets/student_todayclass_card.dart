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
  final bool? isClassHistory; //Check if card is for class history

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
    this.isClassHistory,
  });

  @override
  State<StatefulWidget> createState() => _StudentTodayclassCardState();
}

class _StudentTodayclassCardState extends State<StudentTodayclassCard> {
  @override
  Widget build(BuildContext context) {
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
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text("Image not found"),
                  ),
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
              if (widget.isClassHistory == true)
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.02,
                  right: MediaQuery.of(context).size.height * 0.02,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: widget.publishStatus == "Published"
                          ? Colors.green.withOpacity(1)
                          : Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.publishStatus == "Published"
                          ? "Summary Available"
                          : "No Summary",
                      style: const TextStyle(
                        fontSize: 9,
                        fontFamily: 'Figtree',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              //Class Info Section
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.12,
                  bottom: MediaQuery.of(context).size.height * 0.01,
                  left: MediaQuery.of(context).size.height * 0.02,
                  right: MediaQuery.of(context).size.height * 0.05,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Class name
                    Flexible(
                      child: Text(
                        "${widget.courseCode} - ${widget.className}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'Figtree',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),
                    //Time
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${widget.timeStart} - ${widget.timeEnd}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    //Class location
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.classLocation,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.lecturerName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
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
