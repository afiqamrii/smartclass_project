// ignore_for_file: await_only_futures, unused_result

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/manage_attendance/widgets/lecturer_class_now_card.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/course_enrollment/views/lecturer_select_course.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/create_class_model.dart';
import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';
import 'package:smartclass_fyp_2024/features/student/views/report_utility/views/student_view_reports_history.dart';
import 'package:smartclass_fyp_2024/features/student/views/widgets/student_todayclass_card.dart';
import 'package:smartclass_fyp_2024/shared/components/unavailablePage.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/notifications/notification_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_summarization/lecturer_viewSummarization.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_view_class.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classSum_model.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/shared/widgets/loading.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import '../../../shared/data/views/notification_icon.dart';
import 'manage_class/lecturer_show_all_classes.dart';
import '../../../shared/data/models/class_models.dart';

// ignore: must_be_immutable
class LectHomepage extends ConsumerStatefulWidget {
  const LectHomepage({super.key});

  @override
  ConsumerState<LectHomepage> createState() => _LectHomepageState();
}

class _LectHomepageState extends ConsumerState<LectHomepage> {
  bool _isRefreshing = false; // Add loading state
  int limit = 3; // Set the limit for the number of items to display

  Timer? _nowClassRefreshTimer;

  @override
  void initState() {
    super.initState();

    // Refresh "Now Class" every 60 seconds
    _nowClassRefreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (!mounted) return;
      final externalId = ref.read(userProvider).externalId;
      ref.refresh(nowClassProviders(externalId));
    });
  }

  @override
  void dispose() {
    _nowClassRefreshTimer?.cancel();
    super.dispose();
  }

// Handle the refresh and reload data from provider
  Future<void> _handleRefresh(WidgetRef ref, String externalId) async {
    setState(() {
      _isRefreshing = true; // Set loading state to true
    });

    // Invalidate the provider to trigger loading state

    await ref.refresh(classDataProviderSummarizationStatus(externalId));
    await ref.read(userProvider);
    await ref.refresh(classDataProvider(externalId));
    // ignore:
    await ref.refresh(unreadNotificationCountProvider);

    await ref.refresh(nowClassProviders(externalId));

    // Wait for new data to load
    await Future.delayed(
      const Duration(seconds: 3),
    );

    if (!mounted) return; // Check again before calling setState
    setState(() {
      _isRefreshing = false; // Set loading state to false
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final sumData =
        ref.watch(classDataProviderSummarizationStatus(user.externalId));
    final data = ref.watch(classDataProvider(user.externalId));

    //Get now classes
    final currentClassData = ref.watch(nowClassProviders(user.externalId));

    return Scaffold(
      backgroundColor: const Color(0xFF0d1116),
      body: LiquidPullToRefresh(
        onRefresh: () => _handleRefresh(ref, user.externalId),
        color: const Color(0xFF0d1116),
        backgroundColor: Colors.white,
        animSpeedFactor: 3,
        showChildOpacityTransition: false,
        height: 100,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header (same as before)
            SliverAppBar(
              pinned: false,
              expandedHeight: 90,
              backgroundColor: ColorConstants.backgroundColor,
              automaticallyImplyLeading: false,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  color: const Color(0xFF0d1116),
                  padding: const EdgeInsets.only(
                    top: 60,
                    left: 20,
                    right: 20,
                  ),
                  child: Skeletonizer(
                    enabled: _isRefreshing,
                    effect: const ShimmerEffect(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage('assets/pictures/compPicture.jpg'),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user.userName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Figtree',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  user.roleId == 1
                                      ? "Student"
                                      : user.roleId == 2
                                          ? "Lecturer "
                                          : "PPH Staff",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'FigtreeRegular',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const NotificationIcon(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main Content Section
            SliverToBoxAdapter(
              child: Skeletonizer(
                enabled: _isRefreshing,
                effect: const ShimmerEffect(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                      ),
                      child: data.when(
                        data: (classData) {
                          return sumData.when(
                            data: (sumClassData) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                _cardSection(context, user),
                                const SizedBox(height: 10),
                                _nowClassSection(
                                    context, currentClassData, user, limit),
                                _todayClass(context),
                                const SizedBox(height: 0),
                                _classListCard(context, classData, user),
                                const SizedBox(height: 25),
                                _summarizationSection(context, sumClassData),
                              ],
                            ),
                            error: (err, s) => Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(err.toString()),
                            ),
                            loading: () =>
                                _buildSkeletonLoader(count: classData.length),
                          );
                        },
                        error: (err, s) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(err.toString()),
                        ),
                        loading: () => _buildSkeletonLoader(count: 5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Function to dynamically generate skeleton loaders
  Widget _buildSkeletonLoader({int count = 5}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Skeletonizer(
        enabled: _isRefreshing,
        // Show skeleton effect while loading
        child: Column(
          children: List.generate(
            count, // Dynamically set count based on DB data
            (index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
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
        if (classes.isEmpty)
          const Unavailablepage(
            animation: "assets/animations/noClassAnimation.json",
            message: "No summarization available yet.",
          )
        else
          Column(
            children: List.generate(classes.length, (index) {
              //Start of the content in side each card of class summarization
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      toLeftTransition(
                        LecturerViewsummarization(
                          classId: classes[index].classId,
                        ),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 13.0),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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

  Widget _classListCard(
      BuildContext context, List<ClassCreateModel> classDataItem, User user) {
    if (classDataItem.isEmpty) {
      return const Unavailablepage(
        animation: "assets/animations/noClassAnimation.json",
        message: "You have no class yet.",
      );
    } else {
      return SizedBox(
        height: 200, // fixed height for horizontal cards
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          itemCount: classDataItem.length,
          separatorBuilder: (context, index) => const SizedBox(width: 1),
          itemBuilder: (context, index) {
            final classData = classDataItem[index];
            return SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.8, // set width for each card
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    toLeftTransition(
                      LecturerViewClass(classItem: classData),
                    ),
                  );
                },
                child: StudentTodayclassCard(
                  className: classData.courseName,
                  lecturerName: user.name,
                  courseCode: classData.courseCode,
                  classLocation: classData.location,
                  date: classData.date,
                  timeStart: classData.startTime,
                  timeEnd: classData.endTime,
                  publishStatus: "",
                  imageUrl: classData.imageUrl,
                  isClassHistory: false,
                ),
              ),
            );
          },
        ),
      );
    }
  }
}

Widget _cardSection(BuildContext context, User user) {
  return Row(
    children: [
      // Left card (Course Enroll Request)
      Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: () => {
            Navigator.of(context).push(
              toLeftTransition(
                const LecturerSelectCourse(),
              ),
            ),
          },
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 250, 250),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/icons/enroll.png",
                      width: 22,
                      height: 22,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Course Enroll Request',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'FigtreeRegular',
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      const SizedBox(width: 12),

      // Center card (Report Utility Problem)
      Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: () => {
            // Handle tap on the card here
            Navigator.of(context).push(
              toLeftTransition(
                const ViewReportsHistory(),
              ),
            ),
          },
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 250, 250),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/icons/reportIcon.png",
                      width: 22,
                      height: 22,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Report Utility Problem',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'FigtreeRegular',
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      const SizedBox(width: 12),

      // Right card (New Card)
      // Expanded(
      //   flex: 1,
      //   child: GestureDetector(
      //     onTap: () => {
      //       // // Handle tap on the card
      //       // Navigator.of(context).push(
      //       //   toLeftTransition(
      //       //     const AdminControlUtilities(),
      //       //   ),
      //       // ),
      //     },
      //     child: Container(
      //       height: 90,
      //       decoration: BoxDecoration(
      //         color: const Color.fromARGB(255, 250, 250, 250),
      //         borderRadius: BorderRadius.circular(16),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.black.withOpacity(0.2),
      //             blurRadius: 10,
      //             offset: const Offset(0, 4),
      //           ),
      //         ],
      //       ),
      //       child: const Padding(
      //         padding: EdgeInsets.symmetric(
      //           horizontal: 20,
      //           vertical: 10,
      //         ),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Center(
      //               child: Icon(
      //                 Icons.new_releases,
      //                 size: 22,
      //                 color: Colors.blue,
      //               ),
      //             ),
      //             SizedBox(height: 10),
      //             Text(
      //               'Control Utilities',
      //               style: TextStyle(
      //                 fontSize: 10,
      //                 fontFamily: 'FigtreeRegular',
      //                 fontWeight: FontWeight.w600,
      //               ),
      //               maxLines: 2,
      //               textAlign: TextAlign.center,
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    ],
  );
}

Widget _nowClassSection(
    BuildContext context,
    AsyncValue<List<TodayclassCardModels>> currentClassData,
    User user,
    int limit) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(
            'Now Class',
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Figtree',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        currentClassData.when(
          data: (data) {
            if (data.isEmpty) {
              return const Unavailablepage(
                animation: "assets/animations/noClassAnimation.json",
                message: "No Class Today. YAY!",
              );
            } else {
              final classData = ClassCreateModel(
                classId: data[0].classId,
                courseName: data[0].courseName,
                courseCode: data[0].courseCode,
                location: data[0].location,
                startTime: data[0].startTime,
                endTime: data[0].endTime,
                date: data[0].date,
                lecturerId: user.externalId,
                imageUrl: data[0].imageUrl,
              );
              return Column(
                children: List.generate(
                  data.length > limit ? limit : data.length,
                  (index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        toLeftTransition(
                          LecturerViewClass(classItem: classData),
                        ),
                      );
                    },
                    child: LecturerClassNowCard(
                      classId: data[index].classId,
                      userId: user.externalId,
                      className: data[index].courseName,
                      lecturerName: data[index].lecturerName,
                      courseCode: data[index].courseCode,
                      classLocation: data[index].location,
                      timeStart: data[index].startTime,
                      timeEnd: data[index].endTime,
                      imageUrl: data[index].imageUrl,
                    ),
                  ),
                ),
              );
            }
          },
          error: (error, stackTrace) {
            return const SizedBox.shrink();
          },
          loading: () {
            // Show a loading indicator while data is being fetched
            return const LoadingWidget();
          },
        ),
      ],
    ),
  );
}
