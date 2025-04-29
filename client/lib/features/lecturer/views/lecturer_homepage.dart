// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/shared/components/unavailablePage.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_summarization/lecturer_viewSummarization.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_view_class.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classSum_model.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
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

// Handle the refresh and reload data from provider
  Future<void> _handleRefresh(WidgetRef ref, String externalId) async {
    setState(() {
      _isRefreshing = true; // Set loading state to true
    });

    // Invalidate the provider to trigger loading state

    await ref.read(classDataProviderSummarizationStatus(externalId));
    await ref.read(userProvider);
    await ref.read(classDataProvider(externalId));

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

    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: () => _handleRefresh(ref, user.externalId),
        color: Colors.deepPurple,
        backgroundColor: Colors.deepPurple,
        animSpeedFactor: 3,
        showChildOpacityTransition: false,
        height: 50,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              expandedHeight: MediaQuery.of(context).size.height * 0.14,
              toolbarHeight: 0,
              leading: null,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.deepPurple,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Container(
                    color: Colors.deepPurple,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: 20,
                      right: 20,
                    ),
                    child: Skeletonizer(
                      enabled: _isRefreshing,
                      effect: const ShimmerEffect(),
                      child: _headerSection(user, context),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  data.when(
                    data: (classData) {
                      return sumData.when(
                        data: (sumClassData) => Skeletonizer(
                          enabled: _isRefreshing,
                          effect: const ShimmerEffect(),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: _todayClass(context),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: _classListCard(context, classData),
                              ),
                              const SizedBox(height: 25),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: _summarizationSection(
                                    context, sumClassData),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
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
                ],
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

  Row _headerSection(User user, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello ${user.userName} & ${user.externalId}",
                style: const TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 238, 238, 238),
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 5),
              Text.rich(
                TextSpan(
                  text: "Welcome to ",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 238, 238, 238),
                    fontFamily: 'FigtreeRegular',
                  ),
                  children: [
                    TextSpan(
                      text: user.userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 232, 103, 255),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 238, 238, 238),
            ),
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const MyWidget()));
            },
          ),
        ),
      ],
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
                            classId: classes[index].classId),
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
      BuildContext context, List<ClassCreateModel> classDataItem) {
    if (classDataItem.isEmpty) {
      return const Unavailablepage(
        animation: "assets/animations/noClassAnimation.json",
        message: "You have no class yet.",
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 1.0,
        height: 170,

        //Show all class in the card
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
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
}
