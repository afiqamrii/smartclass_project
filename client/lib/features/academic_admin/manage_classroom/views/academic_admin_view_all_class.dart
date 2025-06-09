import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/services/manage_classroom_api.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/views/academic_admin_addclass.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/views/academic_admin_restore.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/classroom_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AcademicAdminViewAllClass extends ConsumerStatefulWidget {
  const AcademicAdminViewAllClass({super.key});

  @override
  ConsumerState<AcademicAdminViewAllClass> createState() =>
      _AcademicAdminViewAllClassState();
}

class _AcademicAdminViewAllClassState
    extends ConsumerState<AcademicAdminViewAllClass> {
  String searchText = '';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late TextEditingController _searchController;

  void _onRefresh() async {
    // ignore: unused_result
    ref.refresh(classroomApiProvider);
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  // Simulate loading more data
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

  //Function to soft delete a classroom
  void softDeleteClassroom(BuildContext context, int classroomId) async {
    //Call api
    await ManageClassroomApi.deleteClassroom(
      context,
      classroomId,
    );
    //Refresh the list
    //fORCE REFRESH
    // ignore: unused_result
    ref.refresh(classroomApiProvider);
  }

  @override
  Widget build(BuildContext context) {
    final classroomAsyncValue = ref.watch(classroomApiProvider);

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
        child: classroomAsyncValue.when(
          data: (classrooms) {
            final filtered = classrooms
                .where(
                    (c) => c.classroomName.toLowerCase().contains(searchText))
                .toList();
            // Sort filtered classrooms by name
            filtered.sort((a, b) => a.classroomName
                .toLowerCase()
                .compareTo(b.classroomName.toLowerCase()));
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
                        vertical: 1,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${filtered.length} Classrooms',
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
                                toLeftTransition(const AcademicAdminRestoreDeletedClass(),),
                              );
                            },
                          ),
                        ]
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
                      horizontal: 1,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final classroom = filtered[index];

                          return Column(
                            children: [
                              Slidable(
                                key: ValueKey(classroom.classroomId),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        // Navigate to edit page or show a dialog
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Edit ${classroom.classroomName}',
                                            ),
                                          ),
                                        );
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit_outlined,
                                      label: 'Edit',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                              'Delete',
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete "${classroom.classroomName}"?',
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
                                                  softDeleteClassroom(
                                                    context,
                                                    classroom.classroomId,
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
                                child: ListTile(
                                  title: Text(
                                    classroom.classroomName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey.withOpacity(0.3),
                                  height: 1,
                                ),
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
      "Select Classroom",
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
            toLeftTransition(const AcademicAdminAddclass()),
          );
        },
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
