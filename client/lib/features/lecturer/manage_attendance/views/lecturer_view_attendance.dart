import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/lecturer/manage_attendance/providers/attendance_providers.dart';

class LecturerViewAttendance extends ConsumerStatefulWidget {
  final int classId;
  const LecturerViewAttendance({super.key, required this.classId});

  @override
  ConsumerState<LecturerViewAttendance> createState() =>
      _LecturerViewAttendanceState();
}

class _LecturerViewAttendanceState
    extends ConsumerState<LecturerViewAttendance> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    // ignore: unused_result
    ref.refresh(attendanceProvider(widget.classId));
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
    final attendanceAsync = ref.watch(attendanceProvider(widget.classId));

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
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase();
                  });
                },
                onClear: () {
                  setState(() {
                    searchText = '';
                    _searchController.clear();
                  });
                },
              ),
            ),
            attendanceAsync.when(
              data: (attendanceList) {
                final filtered = attendanceList
                    .where((item) =>
                        item.studentName.toLowerCase().contains(searchText) ||
                        item.studentEmail.toLowerCase().contains(searchText) ||
                        item.studentId
                            .toString()
                            .toLowerCase()
                            .contains(searchText))
                    .toList();

                if (filtered.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text("No attendance data found.")),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = filtered[index];
                      return Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.indigo,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.studentName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.studentEmail,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        "Matric No: ${item.studentId}",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Chip(
                                    label: Text(
                                      item.attendanceStatus,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide.none,
                                    ),
                                    side: BorderSide.none,
                                    backgroundColor:
                                        item.attendanceStatus.toLowerCase() ==
                                                'present'
                                            ? Colors.green.shade100
                                            : Colors.red.shade100,
                                    labelStyle: TextStyle(
                                      color:
                                          item.attendanceStatus.toLowerCase() ==
                                                  'present'
                                              ? Colors.green.shade700
                                              : Colors.red.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: Colors.indigo,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Checked in at: ${item.attendanceTime}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            if (index < filtered.length - 1)
                              Divider(
                                color: Colors.grey.withOpacity(0.3),
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: filtered.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => const SliverFillRemaining(
                child: Center(
                  child: Text(
                    "No students found in this class",
                  ),
                ),
              ),
            ),
          ],
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
      "Class Attendance",
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
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  _SearchBarDelegate({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

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
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
              size: 23,
            ),
            hintText: 'Search student...',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
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
