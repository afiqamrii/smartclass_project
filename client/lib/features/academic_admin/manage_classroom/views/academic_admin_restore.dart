// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/providers/manage_classroom_provider.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/services/manage_classroom_api.dart';

class AcademicAdminRestoreDeletedClass extends ConsumerStatefulWidget {
  const AcademicAdminRestoreDeletedClass({super.key});

  @override
  ConsumerState<AcademicAdminRestoreDeletedClass> createState() =>
      _AcademicAdminRestoreDeletedClassState();
}

class _AcademicAdminRestoreDeletedClassState
    extends ConsumerState<AcademicAdminRestoreDeletedClass> {
  bool selectionMode = false;
  final Set<int> selectedIds = {};

  //Restore classroom
  void restoreClassroom(BuildContext context, int classroomId) async {
    await ManageClassroomApi.restoreClassroom(context, classroomId);
    ref.refresh(softDeletedClassroomProvider);
  }

  //Delete classroom
  void deleteClassroom(BuildContext context, int classroomId) async {
    await ManageClassroomApi.deleteClassroomPermanently(context, classroomId);
    ref.refresh(softDeletedClassroomProvider);
  }

  //Delete selected classrooms
  void deleteSelectedClassrooms(BuildContext context) async {
    for (final id in selectedIds) {
      await ManageClassroomApi.deleteClassroomPermanently(context, id);
    }
    selectedIds.clear();
    selectionMode = false;

    ref.refresh(softDeletedClassroomProvider);
  }

  @override
  Widget build(BuildContext context) {
    final deletedClassroomsAsync = ref.watch(softDeletedClassroomProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          selectionMode
              ? "${selectedIds.length} Selected"
              : "Restore Deleted Classrooms",
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
      body: deletedClassroomsAsync.when(
        data: (deletedClassrooms) {
          if (deletedClassrooms.isEmpty) {
            return const Center(child: Text('No deleted classrooms.'));
          }

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Deleted History : ${deletedClassrooms.length}',
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
                              title: const Text('Delete Selected Classrooms'),
                              content: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Are you sure you want to delete the selected classrooms? The classroom that used this classroom also will be deleted. \n\nTHIS ACTION CANNOT BE UNDONE.',
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText:
                                            'Type "Delete Class" to confirm',
                                      ),
                                      validator: (value) {
                                        if (value != null &&
                                            value.trim().toLowerCase() !=
                                                'delete class') {
                                          return 'Please type "Delete Class" to confirm';
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
                                          'delete class') {
                                        deleteSelectedClassrooms(context);
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
                  itemCount: deletedClassrooms.length,
                  itemBuilder: (context, index) {
                    final classroom = deletedClassrooms[index];
                    final isSelected =
                        selectedIds.contains(classroom.classroomId);
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
                              classroom.classroomName,
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
                                          selectedIds
                                              .add(classroom.classroomId);
                                        } else {
                                          selectedIds
                                              .remove(classroom.classroomId);
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
                                                'Are you sure you want to restore this classroom?'),
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
                                        restoreClassroom(
                                            context, classroom.classroomId);
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
