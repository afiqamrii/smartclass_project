import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/assign_lecturer/providers/assign_lecturer_provider.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/assign_lecturer/views/academician_assign_lecturer_page.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class AcademicianViewAssignedLect extends ConsumerStatefulWidget {
  final int courseId;
  final String courseName;
  final String courseCode;

  const AcademicianViewAssignedLect({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.courseCode,
  });

  @override
  ConsumerState<AcademicianViewAssignedLect> createState() =>
      _AcademicianViewAssignedLectState();
}

class _AcademicianViewAssignedLectState
    extends ConsumerState<AcademicianViewAssignedLect> {
  String searchText = '';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late TextEditingController _searchController;

  void _onRefresh() async {
    ref.invalidate(assignedLecturersProvider(widget.courseId));
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
      setState(() {}); // Update UI when text changes
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assignedLecturersAsyncValue =
        ref.watch(assignedLecturersProvider(widget.courseId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Assigned Lecturers",
          style: TextStyle(
            fontSize: 14,
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
          IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.add_outlined,
                size: 23,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                toLeftTransition(
                  AssignLecturerPage(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                    courseCode: widget.courseCode,
                  ),
                ),
              );
            },
          ),
        ],
      ),
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
        child: assignedLecturersAsyncValue.when(
          data: (lecturers) {
            final filtered = lecturers
                .where((l) =>
                    l.name.toLowerCase().contains(searchText.toLowerCase()))
                .toList();

            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: false,
                  delegate: _SearchBarDelegate(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    controller: _searchController,
                    onClear: () {
                      setState(() {
                        searchText = '';
                        _searchController.clear();
                      });
                    },
                  ),
                ),
                if (filtered.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(19.0),
                        child: Text(
                          'No lecturers found.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final lecturer = filtered[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: ListTile(
                                title: Text(
                                  lecturer.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  lecturer.userEmail,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Divider(
                                color: Colors.grey.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: filtered.length,
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
            hintText: 'Search lecturer...',
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
