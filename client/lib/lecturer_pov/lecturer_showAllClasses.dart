// ignore: file_names
import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_createclass.dart';
import 'package:smartclass_fyp_2024/services/api.dart';
import '../models/class_models.dart';

class LectViewAllClass extends StatelessWidget {
  const LectViewAllClass({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch data from the database
    Future<List<ClassModel>> fetchClasses() async {
      const String apiUrl =
          'http://10.0.2.2:3000/class/'; // Replace with your API URL
      return await Api.getClassData(apiUrl);
    }

    return Scaffold(
      appBar: appBar(context),
      body: FutureBuilder<List<ClassModel>>(
        future: fetchClasses(),
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
            return _todayClassesSection(classes, context);
          }
        },
      ),
    );
  }

  // Today's Classes Section
  Padding _todayClassesSection(List<ClassModel> classes, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Today's Classes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount:
                  classes.length + 1, // Include the "Create Class" button
              itemBuilder: (context, index) {
                if (index < classes.length) {
                  final classItem = classes[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${classItem.courseCode} - ${classItem.courseName}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 20),
                                const SizedBox(width: 8.0),
                                Text(classItem.location),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.access_time_outlined,
                                    size: 20),
                                const SizedBox(width: 8.0),
                                Text(
                                    "${classItem.startTime} - ${classItem.endTime}"),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_outlined,
                                        size: 20),
                                    const SizedBox(width: 8.0),
                                    Text(classItem.date),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Handle "View All" action here
                                  },
                                  child: const Text(
                                    "View all >",
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LectCreateClass()),
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        label: const Text(
                          "Create Class",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff323232),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(54.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 16.0),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // App Bar Section
  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 90,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              SizedBox(width: 5),
              Text(
                "Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      titleSpacing: 0,
    );
  }
}
