import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/providers/manage_classroom_provider.dart';

class AcademicAdminRestoreDeletedClass extends ConsumerWidget {
  const AcademicAdminRestoreDeletedClass({super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletedClassroomsAsync = ref.watch(softDeletedClassroomProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restore Classrooms'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: deletedClassroomsAsync.when(
        data: (deletedClassrooms) {
          if (deletedClassrooms.isEmpty) {
            return const Center(child: Text('No deleted classrooms.'));
          }

          return ListView.builder(
            itemCount: deletedClassrooms.length,
            itemBuilder: (context, index) {
              final classroom = deletedClassrooms[index];
              return ListTile(
                title: Text(classroom.classroomName),
                trailing: IconButton(
                  icon: const Icon(Icons.restore, color: Colors.green),
                  onPressed: () async {
                    // await ManageClassroomApi.restoreClassroom(context, classroom.classroomId);
                    // ref.invalidate(deletedClassroomsProvider);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('${classroom.classroomName} restored')),
                    // );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

