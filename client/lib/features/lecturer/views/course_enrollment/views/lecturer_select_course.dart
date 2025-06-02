import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/course_enrollment/views/lecturer_view_enroll_request.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/providers/course_providers.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class LecturerSelectCourse extends ConsumerStatefulWidget {
  const LecturerSelectCourse({super.key});

  @override
  ConsumerState<LecturerSelectCourse> createState() =>
      _LecturerSelectCourseState();
}

class _LecturerSelectCourseState extends ConsumerState<LecturerSelectCourse> {
  String searchText = '';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // ignore: unused_result
    ref.refresh(
        courseListByLecturerIdProvider(ref.read(userProvider).externalId));
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    //Get user data
    final user = ref.watch(userProvider);

    final courseByLecturerAsyncValue =
        ref.watch(courseListByLecturerIdProvider(user.externalId));

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
                  pinned: true,
                  delegate: _SearchBarDelegate(
                    onChanged: (value) {
                      setState(() {
                        searchText = value.toLowerCase();
                      });
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
                        vertical: 16,
                      ),
                      child: Text(
                        '${filtered.length} Courses',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
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
                      horizontal: 15,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final courses = filtered[index];
                          return Column(
                            children: [
                              // GestureDetector to navigate to AdminControlUtilities
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    toLeftTransition(
                                      LecturerViewEnrollRequest(
                                        lecturerId: user.externalId,
                                        courseId: courses.courseId,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 7,
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
                                      const Icon(
                                        Icons.chevron_right,
                                        size: 23,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Divider to separate each classroom
                              // Only show divider if it's not the last item
                              if (index < filtered.length - 1)
                                Divider(
                                  color: Colors.grey.withOpacity(0.3),
                                  thickness: 1,
                                  indent: 5,
                                  endIndent: 5,
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
      "Select Course",
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
  );
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final ValueChanged<String> onChanged;

  _SearchBarDelegate({required this.onChanged});

  @override
  double get minExtent => 70;
  @override
  double get maxExtent => 70;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            hintText: 'Search...',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
              size: 23,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchBarDelegate oldDelegate) => false;
}
