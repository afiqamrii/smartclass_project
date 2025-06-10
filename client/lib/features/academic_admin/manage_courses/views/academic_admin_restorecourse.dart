// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/providers/course_provider.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/services/manage_course_api.dart';

class AcademicAdminRestorecourse extends ConsumerStatefulWidget {
  const AcademicAdminRestorecourse({super.key});

  @override
  ConsumerState<AcademicAdminRestorecourse> createState() =>
      _AcademicAdminRestorecourseState();
}

class _AcademicAdminRestorecourseState
    extends ConsumerState<AcademicAdminRestorecourse> {
  bool selectionMode = false;
  final Set<int> selectedIds = {};

  //Restore course
  void restoreCourse(BuildContext context, int courseId) async {
    await ManageCourseApi.restoreCourses(context, courseId);
    ref.refresh(softDeletedCoursesProvider);
  }

  //Delete course
  void deleteCourse(BuildContext context, int courseId) async {
    await ManageCourseApi.deleteClassroomPermanently(context, courseId);
    ref.refresh(softDeletedCoursesProvider);
  }

  //Delete selected courses
  void deleteSelectedCourses(BuildContext context) async {
    for (final id in selectedIds) {
      await ManageCourseApi.deleteClassroomPermanently(context, id);
    }
    selectedIds.clear();
    selectionMode = false;

    ref.refresh(softDeletedCoursesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final deletedCoursesAsync = ref.watch(softDeletedCoursesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          selectionMode
              ? "${selectedIds.length} Selected"
              : "Restore Deleted Courses",
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            selectionMode ? Icons.close : Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            if (selectionMode) {
              setState(() {
                selectionMode = false;
                selectedIds.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: deletedCoursesAsync.when(
        data: (deletedCourses) {
          if (deletedCourses.isEmpty) {
            return const Center(child: Text('No deleted courses.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Deleted History : ${deletedCourses.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    if (!selectionMode)
                      TextButton(
                        child: const Text(
                          'Select',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        onPressed: () {
                          // Enable selection mode
                          setState(() {
                            selectionMode = true;
                          });
                        },
                      ),
                    if (selectionMode && selectedIds.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          //Show dialog
                          final formKey = GlobalKey<FormState>();
                          String confirmDelete = '';

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Selected Courses'),
                              content: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Are you sure you want to delete the selected course? The classroom that used this course also will be deleted. \n\nTHIS ACTION CANNOT BE UNDONE.',
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText:
                                            'Type "Delete Course" to confirm',
                                      ),
                                      validator: (value) {
                                        if (value != null &&
                                            value.trim().toLowerCase() !=
                                                'delete course') {
                                          return 'Please type "Delete Course" to confirm';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) =>
                                          confirmDelete = value!,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      if (confirmDelete.trim().toLowerCase() ==
                                          'delete course') {
                                        deleteSelectedCourses(context);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: deletedCourses.length,
                  itemBuilder: (context, index) {
                    final course = deletedCourses[index];
                    final isSelected = selectedIds.contains(course.courseId);
                    return Column(
                      children: [
                        Card(
                          color: isSelected
                              ? Colors.red[100]
                              : const Color(0xFFF5F5F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            title: Text(
                              course.courseName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            leading: selectionMode
                                ? Checkbox(
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedIds.add(course.courseId);
                                        } else {
                                          selectedIds.remove(course.courseId);
                                        }
                                      });
                                    },
                                  )
                                : null,
                            trailing: !selectionMode
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.restore,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Confirm restore'),
                                            content: const Text(
                                                'Are you sure you want to restore this course?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (confirm == true) {
                                        restoreCourse(context, course.courseId);
                                      }
                                    },
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
