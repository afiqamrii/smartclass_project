// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';
import 'package:smartclass_fyp_2024/features/student/providers/student_class_provider.dart';
import 'package:smartclass_fyp_2024/features/student/views/report_utility/views/report_utility_page.dart';
import 'package:smartclass_fyp_2024/features/student/views/report_utility/views/view_reports_history.dart';
import 'package:smartclass_fyp_2024/features/student/views/template/student_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/features/student/views/widgets/classnow_card.dart';
import 'package:smartclass_fyp_2024/features/student/views/widgets/student_todayclass_card.dart';
import 'package:smartclass_fyp_2024/features/student/views/widgets/tabs_item.dart';
import 'package:smartclass_fyp_2024/shared/components/unavailablePage.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/shared/widgets/loading.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({super.key});

  @override
  ConsumerState<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<StudentHomePage> {
  bool _isRefreshing = false; // Add loading state
  int limit = 3; // Set the limit for the number of items to display
  int _tabIndex = 0;

// Handle the refresh and reload data from provider
  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() {
      _isRefreshing = true;
    });

    await ref.read(userProvider.notifier).refreshUserData();
    await ref.read(nowClassProviders);
    // ignore: duplicate_ignore
    // ignore: unused_result
    ref.refresh(upcomingClassProviders.future);
    ref.refresh(pastClassProviders.future);
    ref.refresh(todayClassProviders);
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the user data from provider
    final user = ref.watch(userProvider);

    //Get the data from provider
    //Today class
    final todayClassData = ref.watch(todayClassProviders);

    //Upcoming class
    final upcomingClassData = ref.watch(upcomingClassProviders);

    //Past class
    final pastClassData = ref.watch(pastClassProviders);

    //Get now/current class
    final currentClassData = ref.watch(nowClassProviders);
    // final sumData = ref.watch(classDataProviderSummarizationStatus);

    return Scaffold(
      backgroundColor: const Color(0xFF0d1116),
      body: LiquidPullToRefresh(
        onRefresh: () => _handleRefresh(ref),
        color: const Color(0xFF0d1116),
        springAnimationDurationInMilliseconds: 350,
        showChildOpacityTransition: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: false,
              expandedHeight: 90,
              backgroundColor:
                  ColorConstants.backgroundColor, // Set background color
              elevation: 0, // No shadow
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin, // Avoid stretching/mismatch
                background: Container(
                  color: const Color(0xFF0d1116),
                  padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
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
                              backgroundImage: AssetImage(
                                'assets/pictures/compPicture.jpg',
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Student name
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
                                          ? "Lecturer"
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
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              color: Color.fromARGB(255, 238, 238, 238),
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const MyWidget()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                        top: 10.0,
                        left: 12,
                        right: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Add search bar
                          _nowClassSection(currentClassData, user),
                          const SizedBox(height: 15),
                          //Add card section
                          _cardSection(context),
                          const SizedBox(height: 12),
                          //Featured courses section
                          _featuresCourseSection(context),
                          const SizedBox(height: 30),
                          //Add card section
                          DefaultTabController(
                            length: 3,
                            initialIndex: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: Container(
                                    height: 35,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: TabBar(
                                      onTap: (index) {
                                        setState(() => _tabIndex = index);
                                      },
                                      physics: const BouncingScrollPhysics(),
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      dividerColor: Colors.transparent,
                                      labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      indicator: ShapeDecoration(
                                        color: ColorConstants.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      labelColor: Colors.white,
                                      unselectedLabelColor: Colors.black54,
                                      tabs: const [
                                        TabItem(
                                          title: "Today's Class",
                                        ),
                                        TabItem(
                                          title: 'Upcoming',
                                        ),
                                        TabItem(
                                          title: 'Class History',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  child: IndexedStack(
                                    index: _tabIndex,
                                    children: [
                                      _classSection(todayClassData),
                                      _upcomingClassSection(upcomingClassData),
                                      _viewPastClass(pastClassData),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _classSection(AsyncValue<List<TodayclassCardModels>> todayClassData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 5),
        todayClassData.when(
          data: (data) {
            if (data.isEmpty) {
              return const Unavailablepage(
                animation: "assets/animations/noClassAnimation.json",
                message: "No Class Today. YAY!",
              );
            } else {
              return GestureDetector(
                onTap: () => {
                  // Handle tap on class card here
                  // For example, navigate to class details page
                },
                child: Column(
                  children: List.generate(
                    data.length > limit ? limit : data.length,
                    (index) => StudentTodayclassCard(
                      className: data[index].courseName,
                      lecturerName: data[index].lecturerName,
                      courseCode: data[index].courseCode,
                      classLocation: data[index].location,
                      date: data[index].date,
                      timeStart: data[index].startTime,
                      timeEnd: data[index].endTime,
                      publishStatus: data[index].publishStatus,
                      imageUrl: data[index].imageUrl,
                      isClassHistory: false,
                    ),
                  ),
                ),
              );
            }
          },
          error: (error, stackTrace) {
            // Handle the error here
            return const Unavailablepage(
              animation: "assets/animations/unavailableAnimation.json",
              message: "Class not found",
            );
          },
          loading: () {
            // Show a loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        const SizedBox(height: 10),
        // Add a button to view all classes

        todayClassData.when(
          data: (data) {
            if (data.length > limit) {
              return GestureDetector(
                onTap: () => {
                  // Handle tap on "View All" button here
                  // For example, navigate to class list page
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Show All',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[600],
                      size: 12,
                    ),
                  ],
                ),
              );
            } else if (data.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Unavailablepage(
                    animation: "assets/animations/noClassAnimation.json",
                    message: "You only got ${data.length} class today."),
              );
              // Or any fallback widget
            } else {
              return const SizedBox.shrink();
            }
          },
          error: (error, stackTrace) {
            // Handle the error here
            return const Unavailablepage(
              animation: "assets/animations/unavailableAnimation.json",
              message: "Class not found",
            );
          },
          loading: () {
            // Show a loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }

  Widget _upcomingClassSection(
      AsyncValue<List<TodayclassCardModels>> upcomingClassData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 5),
        upcomingClassData.when(
          data: (data) {
            if (data.isEmpty) {
              return const Unavailablepage(
                animation: "assets/animations/noClassAnimation.json",
                message: "No Upcoming Class.",
              );
            } else {
              return GestureDetector(
                onTap: () => {
                  // Handle tap on class card here
                  // For example, navigate to class details page
                },
                child: Column(
                  children: List.generate(
                    data.length > limit ? limit : data.length,
                    (index) => StudentTodayclassCard(
                      className: data[index].courseName,
                      lecturerName: data[index].lecturerName,
                      courseCode: data[index].courseCode,
                      classLocation: data[index].location,
                      date: data[index].date,
                      timeStart: data[index].startTime,
                      timeEnd: data[index].endTime,
                      publishStatus: data[index].publishStatus,
                      imageUrl: data[index].imageUrl,
                      isClassHistory: false,
                    ),
                  ),
                ),
              );
            }
          },
          error: (error, stackTrace) {
            // Handle the error here
            return const Unavailablepage(
              animation: "assets/animations/unavailableAnimation.json",
              message: "Class not found",
            );
          },
          loading: () {
            // Show a loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        const SizedBox(height: 10),
        // Add a button to view all classes only if there are more than limit classes
        upcomingClassData.when(
          data: (data) {
            if (data.length > limit) {
              return GestureDetector(
                onTap: () => {
                  // Handle tap on "View All" button here
                  // For example, navigate to class list page
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Show All',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[600],
                      size: 12,
                    ),
                  ],
                ),
              );
            } else if (data.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Unavailablepage(
                    animation: "assets/animations/noClassAnimation.json",
                    message: "You only got ${data.length} class today."),
              );
              // Or any fallback widget
            } else {
              return const SizedBox.shrink();
            }
          },
          error: (error, stackTrace) {
            // Handle the error here
            return const Unavailablepage(
              animation: "assets/animations/unavailableAnimation.json",
              message: "Class not found",
            );
          },
          loading: () {
            // Show a loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }

  Widget _viewPastClass(AsyncValue<List<TodayclassCardModels>> pastClassData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 5),
        pastClassData.when(
          data: (data) {
            if (data.isEmpty) {
              return const Unavailablepage(
                animation: "assets/animations/unavailableAnimation.json",
                message: "No Past Class",
              );
            } else {
              return GestureDetector(
                onTap: () => {
                  // Handle tap on class card here
                  // For example, navigate to class details page
                },
                child: Column(
                  children: List.generate(
                    data.length > limit ? limit : data.length,
                    (index) => StudentTodayclassCard(
                      className: data[index].courseName,
                      lecturerName: data[index].lecturerName,
                      courseCode: data[index].courseCode,
                      classLocation: data[index].location,
                      date: data[index].date,
                      timeStart: data[index].startTime,
                      timeEnd: data[index].endTime,
                      publishStatus: data[index].publishStatus,
                      imageUrl: data[index].imageUrl,
                      isClassHistory: true,
                    ),
                  ),
                ),
              );
            }
          },
          error: (error, stackTrace) {
            // Handle the error here
            return const Unavailablepage(
              animation: "assets/animations/unavailableAnimation.json",
              message: "Class not found",
            );
          },
          loading: () {
            // Show a loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        const SizedBox(height: 10),
        // Add a button to view all classes

        pastClassData.when(
          data: (data) {
            if (data.length > limit) {
              return GestureDetector(
                onTap: () => {
                  // Handle tap on "View All" button here
                  Navigator.of(context).push(
                    toLeftTransition(
                      const StudentBottomNavbar(initialIndex: 1),
                    ),
                  ),
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Show All',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[600],
                        size: 12,
                      ),
                    ],
                  ),
                ),
              );
            } else if (data.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Unavailablepage(
                    animation: "assets/animations/noClassAnimation.json",
                    message: "You only got ${data.length} class today."),
              );
              // Or any fallback widget
            } else {
              return const SizedBox.shrink();
            }
          },
          error: (error, stackTrace) {
            // Handle the error here
            return const Unavailablepage(
              animation: "assets/animations/unavailableAnimation.json",
              message: "Class not found",
            );
          },
          loading: () {
            // Show a loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }

  Column _featuresCourseSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Courses',
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Figtree',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150, // Set a fixed height for the ListView
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none, // Make it horizontal
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 10), // Add spacing between items
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2nd Card Section
  Widget _cardSection(BuildContext context) {
    return Row(
      children: [
        // Left card
        Expanded(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                "Left Card",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'FigtreeRegular',
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Right card (Report Utility Problem)
        Expanded(
          child: GestureDetector(
            onTap: () => {
              // Handle tap on the card here
              Navigator.of(context).push(
                toLeftTransition(
                  const ViewReportsHistory(),
                ),
              ),
            }, // Handle tap on the card
            child: Container(
              height: 65,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/icons/reportIcon.png",
                        width: 22,
                        height: 22,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Report Utility Problem',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'FigtreeRegular',
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _nowClassSection(
      AsyncValue<List<TodayclassCardModels>> currentClassData, User user) {
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
                return Column(
                  children: List.generate(
                      data.length > limit ? limit : data.length,
                      (index) => ClassNowCard(
                            classId: data[index].classId,
                            userId: user.externalId,
                            className: data[index].courseName,
                            lecturerName: data[index].lecturerName,
                            courseCode: data[index].courseCode,
                            classLocation: data[index].location,
                            timeStart: data[index].startTime,
                            timeEnd: data[index].endTime,
                            imageUrl: data[index].imageUrl,
                          )),
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
}
