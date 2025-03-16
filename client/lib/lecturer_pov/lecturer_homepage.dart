import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_viewSummarization.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_view_class.dart';
import 'package:smartclass_fyp_2024/models/lecturer/classSum_model.dart';
import 'package:smartclass_fyp_2024/test.dart';
import 'package:smartclass_fyp_2024/widget/pageTransition.dart';
import 'lecturer_show_all_classes.dart';
import '../models/lecturer/class_models.dart';

// ignore: must_be_immutable
class LectHomepage extends ConsumerWidget {
  const LectHomepage({super.key});

  //Handel the refresh and reload the data from provider to update the data
  Future<void> _handleRefresh(WidgetRef ref) async {
    //Reload the data in class provider
    // ignore: await_only_futures, unused_result
    await ref.refresh(classDataProvider.future);
    // ignore: unused_result, await_only_futures
    await ref.refresh(classDataProviderSummarizationStatus.future);
    //reloading take some time..
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // getClasses();
    //get data from provider
    final data = ref.watch(classDataProvider);
    final sumData = ref.watch(classDataProviderSummarizationStatus);
    final user = ref.watch(userProvider);
    return Scaffold(
      body: data.when(
        data: (data) {
          List<ClassModel> classData = data;
          return sumData.when(
            data: (sumData) {
              List<ClassSumModel> sumClassData = sumData;
              return LiquidPullToRefresh(
                onRefresh: () => _handleRefresh(ref),
                color: Colors.deepPurple,
                height: 100,
                backgroundColor: Colors.deepPurple[200],
                animSpeedFactor: 4,
                showChildOpacityTransition: false,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 18.0,
                    top: 10,
                  ),
                  child: ListView(
                    children: [
                      //Top title section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Hello Dr. Afiq top title
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello ${user.userName}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //Welcome to Smart Class top title
                              const Text.rich(
                                TextSpan(
                                  text: "Welcome to ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Smart Class",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //Right Side for notification icon
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: IconButton(
                              icon: const Icon(Icons.notifications,
                                  color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyWidget()));
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Today's Classes Header
                      _todayClass(context),
                      const SizedBox(height: 2),
                      // Horizontal scrollable cards
                      _classListCard(context, classData),
                      const SizedBox(height: 20),
                      _summarizationSection(context, sumClassData),
                    ],
                  ),
                ),
              );
            },
            error: (err, s) => Text(err.toString()),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        error: (err, s) => Text(err.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Column _summarizationSection(
      BuildContext context, List<ClassSumModel> sumClassData) {
    List<ClassSumModel> classes = sumClassData;
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Summarization",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            //SAmbung after this to view all the summariazatiopn
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const LectViewAllClass()));
            //   },
            //   child: const Padding(
            //     padding: EdgeInsets.only(right: 10.0),
            //     child: Text(
            //       "View All >",
            //       style: TextStyle(
            //         fontSize: 11,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.purple,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 10),
        //Start of Card of Class Summarization Status
        Column(
          children: List.generate(classes.length, (index) {
            //Start of the content in side each card of class summarization
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    toLeftTransition(
                      LecturerViewsummarization(
                          classId: classes[index].classId),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 13.0, right: 20.0),
                child: IntrinsicHeight(
                  child: Container(
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
                      padding: const EdgeInsets.all(18.0),
                      //Start of the content in side each card of class summarization
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${classes[index].courseCode} - ${classes[index].courseName}',
                                ),
                                const SizedBox(height: 20),
                                //Class Time
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      classes[index].location,
                                      style: const TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
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
                                        fontSize: 11,
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
                                        fontSize: 11,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              //Summarization Status
                              children: [
                                Container(
                                  width: 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: classes[index].recordingStatus ==
                                            "Summarized"
                                        ? const Color(0xff00A619)
                                        : const Color(0xffCC3300),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        classes[index].recordingStatus,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Color(0xffFFFFFF),
                                        ),
                                      ),
                                    ],
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
          }),
        ),
      ],
    );
  }

  Row _todayClass(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "All Classes",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              toLeftTransition(
                const LectViewAllClass(),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Text(
              "View all >",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _classListCard(
      BuildContext context, List<ClassModel> classDataItem) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1.0,
      height: 170,

      //Show all class in the card
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: classDataItem.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final classData = classDataItem[index];
          return GestureDetector(
            onTap: () {
              // Navigate to class detail page
              Navigator.push(
                context,
                toLeftTransition(
                  LecturerViewClass(
                    classItem: classData,
                  ),
                ),
              );
            },
            child: IntrinsicHeight(
              child: IntrinsicWidth(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 300,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      //Give the shadow to the card
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.35),
                          spreadRadius: 0,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 200,
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
                                  size: 16, color: Colors.black54),
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
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
