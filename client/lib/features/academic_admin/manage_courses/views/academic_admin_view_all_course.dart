import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/services/manage_course_api.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/views/academic_admin_addcourse.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/views/academic_admin_editcourse.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/views/academic_admin_restorecourse.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/providers/course_providers.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class AcademicAdminViewAllCourse extends ConsumerStatefulWidget {
  const AcademicAdminViewAllCourse({super.key});

  @override
  ConsumerState<AcademicAdminViewAllCourse> createState() =>
      _AcademicAdminViewAllCourseState();
}

class _AcademicAdminViewAllCourseState
    extends ConsumerState<AcademicAdminViewAllCourse> {
  String searchText = '';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late TextEditingController _searchController;

  void _onRefresh() async {
    // ignore: unused_result
    ref.refresh(courseListProvider);
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

  //Method to soft delete
  void softDeleteCourse(BuildContext context, int courseId) async {
    await ManageCourseApi.softDeleteCourse(
      context,
      courseId,
    );
    //Refresh
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    //Get user data
    // ignore: unused_local_variable
    final user = ref.watch(userProvider);

    // Get the list of courses by lecturer ID
    final courseByLecturerAsyncValue = ref.watch(courseListProvider);

    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const ClassicHeader(
          releaseIcon: Icon(
            Icons.arrow_upward,
            color: Colors.grey,
          ),
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: courseByLecturerAsyncValue.when(
          data: (courses) {
            final filtered = courses
                .where((c) => c.courseName.toLowerCase().contains(searchText))
                .toList();
            // Sort filtered courses by name
            filtered.sort((a, b) => a.courseName
                .toLowerCase()
                .compareTo(b.courseName.toLowerCase()));
            //Show the filtered classrooms in a list
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: false,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${filtered.length} Courses',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.restore_from_trash_outlined,
                              color: Colors.black,
                              size: 20,
                            ),
                            tooltip: 'Restore Deleted',
                            onPressed: () {
                              Navigator.push(
                                context,
                                toLeftTransition(
                                  const AcademicAdminRestorecourse(),
                                ),
                              );

                              //Refresh the list
                              // ignore: unused_result
                              ref.refresh(courseListProvider);
                            },
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final courses = filtered[index];
                          return Column(
                            children: [
                              Slidable(
                                key: ValueKey(courses.courseId),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    //Edit button
                                    SlidableAction(
                                      onPressed: (context) {
                                        Navigator.push(
                                          context,
                                          toLeftTransition(
                                            AcademicAdminEditcourse(
                                              courseCode: courses.courseCode,
                                              courseId: courses.courseId,
                                              courseName: courses.courseName,
                                            ),
                                          ),
                                        );
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit_outlined,
                                      label: 'Edit',
                                    ),
                                    //Delete button
                                    SlidableAction(
                                      onPressed: (context) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                              'Delete',
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete "${courses.courseName}"?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  //Soft Delete class
                                                  softDeleteCourse(
                                                    context,
                                                    courses.courseId,
                                                    // courses.courseName,
                                                  );
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        courses.courseName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Divider to separate each course
                              if (index < filtered.length - 1)
                                Divider(
                                  color: Colors.grey.withOpacity(0.3),
                                  thickness: 1,
                                  // indent: 5,
                                  // endIndent: 5,
                                ),
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
      "All Courses",
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
        padding: const EdgeInsets.only(right: 10.0),
        child: IconButton(
          icon: const Icon(
            Icons.add_outlined,
            size: 23,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              toLeftTransition(
                const AcademicAdminAddcourse(),
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
