// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/providers/course_providers.dart';
import 'package:smartclass_fyp_2024/features/student/views/widgets/student_todayclass_card.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_view_class.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/template/lecturer_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import 'lecturer_create_class.dart';
import '../../../../shared/data/models/class_models.dart';

class LectViewAllClass extends ConsumerStatefulWidget {
  const LectViewAllClass({super.key});

  @override
  ConsumerState<LectViewAllClass> createState() => _LectViewAllClassState();
}

class _LectViewAllClassState extends ConsumerState<LectViewAllClass> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Add filter state
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Today", "Upcoming", "Past Class"];

  Future<void> _handleRefresh() async {
    //Refresh the class data
    ref.refresh(classDataProvider(ref.watch(userProvider).externalId));

    // ignore: unused_local_variable
    final courseListAsync = ref.watch(
        courseListByLecturerProvider(ref.watch(userProvider).externalId));

    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final data = ref.watch(classDataProvider(user.externalId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context),
      body: data.when(
        data: (classes) {
          // Apply filtering
          final filtered = classes.where((classItem) {
            final searchLower = _searchQuery.toLowerCase();
            return classItem.courseCode.toLowerCase().contains(searchLower) ||
                classItem.courseName.toLowerCase().contains(searchLower);
          }).toList();

          // Apply date filter
          final now = DateTime.now();
          // final todayStr = "${now.day} ${_monthName(now.month)} ${now.year}";
          List<ClassCreateModel> dateFiltered = filtered.where((classItem) {
            DateTime? classDate;
            try {
              classDate = DateFormat('d MMMM yyyy').parse(classItem.date);
            } catch (_) {
              return false;
            }
            switch (_selectedFilter) {
              case "Today":
                return classDate.year == now.year &&
                    classDate.month == now.month &&
                    classDate.day == now.day;
              case "Upcoming":
                return classDate.isAfter(now);
              case "Past Class":
                return classDate.isBefore(now);
              default:
                return true;
            }
          }).toList();

          return SmartRefresher(
            onRefresh: _handleRefresh,
            enablePullDown: true,
            header: const ClassicHeader(
              releaseIcon: Icon(
                Icons.arrow_upward,
                color: Colors.grey,
              ),
            ),
            onLoading: _onLoading,
            controller: _refreshController,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  floating: true,
                  pinned: false,
                  delegate: _SearchBarDelegate(
                    onChanged: _onSearchChanged,
                    controller: _searchController,
                    onClear: _clearSearch,
                  ),
                ),
                // ---filter chips here ---
                _chipsFilterSection(context),
                // --- End filter chips ---
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 5,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "${dateFiltered.length} Classes Found",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final classItem = dateFiltered[index];
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
                            right: 10.0,
                            left: 10,
                          ),
                          child: StudentTodayclassCard(
                            className: classItem.courseName,
                            lecturerName: user.name,
                            courseCode: classItem.courseCode,
                            classLocation: classItem.location,
                            date: classItem.date,
                            timeStart: classItem.startTime,
                            timeEnd: classItem.endTime,
                            publishStatus: "",
                            imageUrl: classItem.imageUrl,
                            isClassHistory: false,
                          ),
                        ),
                      );
                    },
                    childCount: dateFiltered.length,
                  ),
                ),
              ],
            ),
          );
        },
        error: (err, s) => Center(child: Text(err.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  SliverToBoxAdapter _chipsFilterSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 1,
        ),
        child: Wrap(
          spacing: 7,
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return ChoiceChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() => _selectedFilter = filter);
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: isSelected
                    ? BorderSide.none
                    : BorderSide(color: Colors.grey.shade400),
              ),
              elevation: isSelected ? 3 : 0,
              pressElevation: 5,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            );
          }).toList(),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
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
          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
        ),
      ),
      title: const Text(
        "All Classes",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      shape: Border(
        bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                toLeftTransition(const LectCreateClass()),
              );
            },
            child: Image.asset("assets/icons/add.png", height: 25),
          ),
        ),
      ],
    );
  }

  // Helper to get month name for todayStr
  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
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
