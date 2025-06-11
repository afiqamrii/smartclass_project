// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/student/manage_class/views/student_view_class_details.dart';
import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';
import 'package:smartclass_fyp_2024/features/student/providers/student_class_provider.dart';
import 'package:smartclass_fyp_2024/features/student/views/widgets/student_todayclass_card.dart';
import 'package:smartclass_fyp_2024/master/app_strings.dart';
import 'package:smartclass_fyp_2024/shared/components/unavailablePage.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class StudentMyclass extends ConsumerStatefulWidget {
  const StudentMyclass({super.key});

  @override
  ConsumerState<StudentMyclass> createState() => _StudentMyclassState();
}

class _StudentMyclassState extends ConsumerState<StudentMyclass> {
  // ignore: unused_field
  bool _isRefreshing = false;
  String _selectedFilter = "All"; // default filter
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final List<String> _filters = [
    "All",
    "Yesterday",
    "Last 7 Days",
    "Last 30 Days"
  ];

  void _onRefresh() async {
    ref.refresh(pastClassProviders(ref.read(userProvider).externalId));
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  // Simulate loading more data
  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() => _isRefreshing = true);

    // Invalidate the provider to trigger loading state
    ref.refresh(pastClassProviders(ref.read(userProvider).externalId));

    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    // Get the student ID from the user provider
    final studentId = ref.read(userProvider).externalId;
    final pastClassData = ref.watch(pastClassProviders(studentId));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get("student", "class_history_title")),
        automaticallyImplyLeading: false,
      ),
      body: SmartRefresher(
        physics: const BouncingScrollPhysics(),
        controller: _refreshController,
        enablePullDown: true,
        header: const ClassicHeader(
          releaseIcon: Icon(Icons.arrow_upward, color: Colors.grey),
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Wrap(
                spacing: 7,
                runSpacing: 1,
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _viewPastClass(pastClassData),
            ),
          ],
        ),
      ),
    );
  }

  List<TodayclassCardModels> _filterClasses(
      List<TodayclassCardModels> data, String filter) {
    final now = DateTime.now();
    final formatter = DateFormat('d MMMM yyyy'); // e.g., 14 April 2025

    return data.where((item) {
      DateTime? classDate;
      try {
        classDate = formatter.parse(item.date);
      } catch (_) {
        return false; // Skip if date parsing fails
      }

      switch (filter) {
        case "Yesterday":
          return classDate.isAfter(now.subtract(const Duration(days: 2))) &&
              classDate.isBefore(now);
        case "Last 7 Days":
          return classDate.isAfter(now.subtract(const Duration(days: 7)));
        case "Last 30 Days":
          return classDate.isAfter(now.subtract(const Duration(days: 30)));
        default:
          return true;
      }
    }).toList();
  }

  Widget _viewPastClass(AsyncValue<List<TodayclassCardModels>> pastClassData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        pastClassData.when(
          data: (data) {
            final filteredData = _filterClasses(data, _selectedFilter);
            if (filteredData.isEmpty) {
              return const Unavailablepage(
                animation: "assets/animations/unavailableAnimation.json",
                message: "No Past Class",
              );
            } else {
              return Column(
                children: List.generate(
                  filteredData.length,
                  (index) => GestureDetector(
                    onTap: () => {
                      // Handle tap on class card here
                      Navigator.push(
                          context,
                          toLeftTransition(
                            StudentViewClassDetails(
                              classItem: filteredData[index],
                            ),
                          ))
                    },
                    child: StudentTodayclassCard(
                      className: filteredData[index].courseName,
                      lecturerName: filteredData[index].lecturerName,
                      courseCode: filteredData[index].courseCode,
                      classLocation: filteredData[index].location,
                      date: filteredData[index].date,
                      timeStart: filteredData[index].startTime,
                      timeEnd: filteredData[index].endTime,
                      publishStatus: filteredData[index].publishStatus,
                      imageUrl: filteredData[index].imageUrl,
                      isClassHistory: true,
                    ),
                  ),
                ),
              );
            }
          },
          error: (_, __) => const Unavailablepage(
            animation: "assets/animations/unavailableAnimation.json",
            message: "Class not found",
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
