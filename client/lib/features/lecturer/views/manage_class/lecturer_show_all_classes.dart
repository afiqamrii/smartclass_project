// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_view_class.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/template/lecturer_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import 'lecturer_create_class.dart';
import '../../../../shared/data/models/class_models.dart';

class LectViewAllClass extends ConsumerWidget {
  const LectViewAllClass({super.key});

  // Handle the refresh and reload the data from provider to update the UI
  Future<void> _handleRefresh(WidgetRef ref) async {
    //Reload the data in class provider
    // ignore: await_only_futures
    // await ref.refresh(classDataProvider.future);
    //reloading take some time..
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final data = ref.watch(classDataProvider(user.externalId));
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: appBar(context),
      body: data.when(
        data: (data) {
          List<ClassCreateModel> classes = data;
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
  Padding _todayClassesSection(
      List<ClassCreateModel> classes, BuildContext context) {
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        toLeftTransition(
                          LecturerViewClass(classItem: classItem),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        bottom: 2.0,
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
                                    fontSize: 16,
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
                                        style: const TextStyle(
                                          fontFamily: 'FigtreeRegular',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
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
                                      "${classItem.startTime} - ${classItem.endTime}",
                                      style: const TextStyle(
                                        fontFamily: 'FigtreeRegular',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 20),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          classItem.date,
                                          style: const TextStyle(
                                            fontFamily: 'FigtreeRegular',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return null;
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
            toRightTransition(
              const LectBottomNavBar(initialIndex: 0),
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
        "All Classes",
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
      //action
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  toLeftTransition(
                    const LectCreateClass(),
                  ));
            },
            child: Image.asset(
              "assets/icons/add.png",
              height: 25,
            ),
          ),
        ),
      ],
    );
  }
}
