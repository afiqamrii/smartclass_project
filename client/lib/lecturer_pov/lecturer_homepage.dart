import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_viewSummarization.dart';
import 'package:smartclass_fyp_2024/models/classModels.dart';
import '../services/api.dart';
import '../lecturer_pov/lecturer_showAllClasses.dart';
import '../models/class_models.dart';

class LectHomepage extends StatefulWidget {
  const LectHomepage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LectHomepageState createState() => _LectHomepageState();
}

class _LectHomepageState extends State<LectHomepage> {
  late Future<List<ClassModel>> _classesFuture;

  List<ClasTestModel> classes = [];

  @override
  void initState() {
    super.initState();
    _classesFuture = fetchClasses();
  }

  //Get class dari class model
  void getClasses() {
    classes = ClasTestModel.getClass();
  }

  Future<List<ClassModel>> fetchClasses() async {
    const String apiUrl = 'http://10.0.2.2:3000/class/';
    return await Api.getClassData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    getClasses();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: const Text(
          'Hello Dr. Afiq!',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: ListView(
          children: [
            const Text(
              "Welcome to SmartClass",
              style: TextStyle(fontSize: 16, color: Colors.purple),
            ),
            const SizedBox(height: 20),
            // Today's Classes Header
            _todayClass(context),
            const SizedBox(height: 2),
            // Horizontal scrollable cards
            _classListCard(),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Summarization",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LectViewAllClass()));
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(
                          "View All >",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Column(
                  children: List.generate(classes.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 13.0, right: 20.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          //Give the shadow to the card
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(8, 7),
                            ),
                          ],
                        ),
                        // Card content
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          //Class Title
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${classes[index].courseCode} - ${classes[index].courseName}',
                                    ),
                                    const SizedBox(height: 32),
                                    //Class Time
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.timer_outlined,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${classes[index].startTime} - ${classes[index].endTime}',
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    //Class Date Section
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_rounded,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          classes[index].date,
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              //Right Side of the Card
                              Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  //Summarization Status
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: classes[index].summarization ==
                                                "Available"
                                            ? const Color(0xff00A619)
                                            : const Color(0xffCC3300),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            classes[index].summarization,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xffFFFFFF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //View All Button
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LecturerViewsummarization()));
                                      },
                                      child: const Text(
                                        "View All >",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple,
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
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _todayClass(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Today's Classes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LectViewAllClass()));
          },
          child: const Text(
            "View all >",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
      ],
    );
  }

  FutureBuilder<List<ClassModel>> _classListCard() {
    return FutureBuilder<List<ClassModel>>(
      future: _classesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No classes available.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        } else {
          final classes = snapshot.data!;
          return SizedBox(
            width: MediaQuery.of(context).size.width * 1.0,
            height: 175,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: classes.length,
              separatorBuilder: (context, index) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                final classData = classes[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to class detail page
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => LectClassDetail(
                    //       classData: classData,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course Title
                        Text(
                          "${classData.courseCode} - ${classData.courseName}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              classData.location,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Time
                        Row(
                          children: [
                            const Icon(Icons.schedule,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              "${classData.startTime} - ${classData.endTime}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Date
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              classData.date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
