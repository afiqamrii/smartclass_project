// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_homepage.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_view_class.dart';
import '../lecturer_pov/lecturer_create_class.dart';
import '../models/class_models.dart';

class LectViewAllClass extends ConsumerWidget {
  const LectViewAllClass({super.key});

  // Handle the refresh and reload the data from provider to update the UI
  Future<void> _handleRefresh(WidgetRef ref) async {
    //Reload the data in class provider
    // ignore: await_only_futures
    await ref.refresh(classDataProvider);
    //reloading take some time..
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(classDataProvider);
    return Scaffold(
      appBar: appBar(context),
      body: data.when(
        data: (data) {
          List<ClassModel> classes = data;
          return LiquidPullToRefresh(
            onRefresh: () => _handleRefresh(ref),
            color: Colors.deepPurple,
            height: 100,
            animSpeedFactor: 2,
            backgroundColor: Colors.deepPurple[200],
            showChildOpacityTransition: false,
            child: _todayClassesSection(classes, context),
          );
        },
        error: (err, s) => Text(err.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // Today's Classes Section
  Padding _todayClassesSection(List<ClassModel> classes, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:
                  classes.length + 1, // Include the "Create Class" button
              itemBuilder: (context, index) {
                if (index < classes.length) {
                  final classItem = classes[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      bottom: 5.0,
                      top: 10,
                    ),
                    child: IntrinsicHeight(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //Title of the class
                            children: [
                              Text(
                                "${classItem.courseCode} - ${classItem.courseName}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              //Location of the class
                              SizedBox(
                                width: 250,
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 20),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      classItem.location,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              //Time of the class
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LecturerViewClass(
                                                  classItem: classItem),
                                        ),
                                      );
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
                            fontSize: 15.0,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff323232),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(54.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 13.0),
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
      leading: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LectHomepage(),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18,
              ),
            ],
          ),
        ),
      ),
      title: const Text(
        "Today's Classes",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      //Give a bottom border
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey[300]!,
          width: 1.0,
        ),
      ),
      titleSpacing: 0,
    );
  }
}
