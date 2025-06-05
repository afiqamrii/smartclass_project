import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/lecturer/manage_attendance/providers/attendance_providers.dart';

class LecturerViewAttendance extends ConsumerWidget {
  final int classId;
  const LecturerViewAttendance({super.key, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceProvider(classId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("View Attendance"),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: attendanceAsync.when(
                data: (attendanceList) {
                  return ListView.separated(
                    itemCount: attendanceList.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = attendanceList[index];
                      return ListTile(
                        leading:
                            const CircleAvatar(backgroundColor: Colors.grey),
                        title: Text(
                          item.studentName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text(item.attendanceStatus),
                        trailing: const Icon(Icons.person_outline),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
