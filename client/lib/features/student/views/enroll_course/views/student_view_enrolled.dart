import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/student/views/enroll_course/providers/student_enrollment_providers.dart';
import 'package:smartclass_fyp_2024/features/student/views/enroll_course/views/student_enroll_course.dart';
import 'package:smartclass_fyp_2024/features/student/views/enroll_course/widget/enrollment_card.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class StudentViewEnrolled extends ConsumerStatefulWidget {
  const StudentViewEnrolled({super.key});

  @override
  ConsumerState<StudentViewEnrolled> createState() =>
      _StudentViewEnrolledState();
}

class _StudentViewEnrolledState extends ConsumerState<StudentViewEnrolled> {
  String searchText = '';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late TextEditingController _searchController;

  void _onRefresh() async {
    final user = ref.read(userProvider);
    // Refresh only the student's enrollment list
    ref.invalidate(enrollmentListProvider(user.externalId));
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: searchText);
    _searchController.addListener(() {
      setState(() {}); // Update UI to show/hide clear icon
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<String> _filters = [
    "All", // Default filter
    "Verified",
    "Pending",
  ];

  String _selectedFilter = "All"; // default filter

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final courseEnrollList = ref.watch(
      enrollmentListProvider(user.externalId),
    );

    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const ClassicHeader(
          releaseIcon: Icon(Icons.arrow_upward, color: Colors.grey),
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: courseEnrollList.when(
          data: (courseEnrolled) {
            final filtered = courseEnrolled.where((c) {
              final matchesSearch =
                  c.courseCode.toLowerCase().contains(searchText) ||
                      c.courseName.toLowerCase().contains(searchText);

              final matchesFilter =
                  _selectedFilter == 'All' ? true : c.status == _selectedFilter;

              return matchesSearch && matchesFilter;
            }).toList();

            // Sort filtered classrooms by name
            filtered.sort((a, b) => a.courseName
                .toLowerCase()
                .compareTo(b.courseName.toLowerCase()));

            //Show the filtered classrooms in a list
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SearchBarDelegate(
                    onChanged: (value) {
                      setState(() {
                        searchText = value.toLowerCase();
                      });
                    },
                    controller: _searchController,
                    onClear: () {
                      setState(
                        () {
                          searchText = '';
                          _searchController.clear();
                        },
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 5,
                            runSpacing: 1,
                            children: _filters.map((filter) {
                              final isSelected = _selectedFilter == filter;
                              return ChoiceChip(
                                label: Text(
                                  filter,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  setState(() => _selectedFilter = filter);
                                },
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: isSelected
                                      ? BorderSide.none
                                      : BorderSide(color: Colors.grey.shade400),
                                ),
                                elevation: isSelected ? 3 : 0,
                                pressElevation: 5,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 5),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          // Display the number of enrolled courses
                          Text(
                            '${filtered.length} Enrolled Courses',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (filtered.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: Text('No classrooms found.')),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 30,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final enrolledCourse = filtered[index];
                          return Column(
                            children: [
                              // GestureDetector to navigate to AdminControlUtilities
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   toLeftTransition(
                                  //     AdminControlUtilities(
                                  //       classroomId: classroom.classroomId,
                                  //       classroomName: classroom.classroomName,
                                  //       classroomDevId:
                                  //           classroom.group_developer_id,
                                  //       esp32Id: classroom.esp32_id,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: CourseStatusCard(
                                  courseName: enrolledCourse.courseName,
                                  courseCode: enrolledCourse.courseCode,
                                  imageUrl: enrolledCourse.courseImageUrl,
                                  isVerified:
                                      enrolledCourse.status == 'Approved'
                                          ? true
                                          : false,
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                          );
                        },
                        childCount: filtered.length,
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

AppBar _appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: const Text(
      "My Enrolled Courses",
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 20,
        color: Colors.black,
      ),
      onPressed: () => Navigator.pop(context),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(
          right: 16.0,
          top: 1,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.black,
            size: 25,
          ),
          onPressed: () {
            // Handle notification button press
            // Navigate to the StudentEnrollCourse page
            Navigator.push(
              context,
              toLeftTransition(
                const StudentEnrollCourse(),
              ),
            );
          },
        ),
      ),
    ],
  );
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final VoidCallback onClear;

  _SearchBarDelegate({
    required this.onChanged,
    required this.controller,
    required this.onClear,
  });

  @override
  double get minExtent => 70;
  @override
  double get maxExtent => 70;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            hintText: 'Search...',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
              size: 23,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.grey,
                      size: 17,
                    ),
                    onPressed: onClear,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchBarDelegate oldDelegate) => true;
}
