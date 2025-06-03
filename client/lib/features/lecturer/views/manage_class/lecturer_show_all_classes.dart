// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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

  Future<void> _handleRefresh() async {
    //Refresh the class data
    ref.refresh(classDataProvider(ref.read(userProvider).externalId));

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
      backgroundColor: const Color(0xffF7F7F7),
      appBar: appBar(context),
      body: data.when(
        data: (classes) {
          // Apply filtering
          final filtered = classes.where((classItem) {
            final searchLower = _searchQuery.toLowerCase();
            return classItem.courseCode.toLowerCase().contains(searchLower) ||
                classItem.courseName.toLowerCase().contains(searchLower);
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
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "${filtered.length} Classes Found",
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
                      final classItem = filtered[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            toLeftTransition(
                              LecturerViewClass(classItem: classItem),
                            ),
                          );
                        },
                        child: _classCardSection(classItem),
                      );
                    },
                    childCount: filtered.length,
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

  Padding _classCardSection(ClassCreateModel classItem) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        bottom: 2.0,
        top: 10,
        right: 20,
      ),
      child: IntrinsicHeight(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${classItem.courseCode} - ${classItem.courseName}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 20),
                    const SizedBox(width: 8.0),
                    Text(
                      classItem.location,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.access_time_outlined, size: 20),
                    const SizedBox(width: 8.0),
                    Text(
                      "${classItem.startTime} - ${classItem.endTime}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 20),
                    const SizedBox(width: 8.0),
                    Text(
                      classItem.date,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
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
