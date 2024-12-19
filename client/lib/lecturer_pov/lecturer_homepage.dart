import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/services/api.dart';
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

  @override
  void initState() {
    super.initState();
    _classesFuture = fetchClasses();
  }

  Future<List<ClassModel>> fetchClasses() async {
    const String apiUrl =
        'http://10.0.2.2:3000/class/'; // Replace with your API URL
    return await Api.getClassData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: const Text(
          'Hello Dr. Nor!',
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to SmartClass",
              style: TextStyle(fontSize: 16, color: Colors.purple),
            ),
            const SizedBox(height: 20),

            // Today's Classes Header
            Row(
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
                    "View all",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),

            // Horizontal scrollable cards
            FutureBuilder<List<ClassModel>>(
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
                    height: 175,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: classes.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 20),
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
            ),
          ],
        ),
      ),
    );
  }
}
