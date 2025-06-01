import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/course_model.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/providers/course_providers.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class StudentEnrollCourse extends ConsumerStatefulWidget {
  const StudentEnrollCourse({super.key});

  @override
  ConsumerState<StudentEnrollCourse> createState() =>
      _StudentEnrollCourseState();
}

class _StudentEnrollCourseState extends ConsumerState<StudentEnrollCourse> {
  final _formKey = GlobalKey<FormState>();
  CourseModel? _selectedCourse;
  final TextEditingController courseController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  // void _enrollCourse(int studentId, int courseId) {
  //   EnrollService.enrollToCourse(
  //     studentId: studentId,
  //     courseId: courseId,
  //     context: context,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final courseListAsync = ref.watch(courseListProvider);

    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: courseListAsync.when(
          data: (courses) => Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildLabel('Student Name'),
                const SizedBox(height: 10),
                _buildReadOnlyBox(user.name),
                const SizedBox(height: 20),
                _buildLabel('Student ID'),
                const SizedBox(height: 10),
                _buildReadOnlyBox(user.externalId.toString()),
                const SizedBox(height: 20),
                _buildLabel('Select Course'),
                const SizedBox(height: 10),
                courseDropdown(
                  context,
                  courseListAsync,
                  courseController,
                  titleController,
                ),
                const SizedBox(height: 30),
                // Enroll button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    //  the following lines to enable course enrollment
                    // if (_formKey.currentState!.validate()) {
                    //   _enrollCourse(user.studentId, _selectedCourse!.courseId);
                    // }
                  },
                  child: const Text(
                    'Enroll Course',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('Error loading courses: $err')),
        ),
      ),
    );
  }

  Widget courseDropdown(
      BuildContext context,
      AsyncValue<List<CourseModel>> courseListAsync,
      TextEditingController controller,
      TextEditingController titleController) {
    return courseListAsync.when(
      data: (courses) {
        if (courses.isEmpty) {
          return const Text("No courses available.");
        }

        return DropdownSearch<CourseModel>(
          asyncItems: (String filter) async {
            return courses
                .where((course) => course
                    .toString()
                    .toLowerCase()
                    .contains(filter.toLowerCase()))
                .toList();
          },
          popupProps: PopupProps.dialog(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search course...",
                hintStyle: const TextStyle(fontSize: 14),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            dialogProps: DialogProps(
              contentPadding: const EdgeInsets.all(5),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
            ),
            itemBuilder: (context, item, isSelected) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    item.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Divider(
                    color: Colors.black.withOpacity(0.2),
                    height: 1,
                  ),
                ],
              ),
            ),
          ),
          itemAsString: (course) => course.toString(),
          onChanged: (selectedCourse) {
            if (selectedCourse != null) {
              controller.text = selectedCourse.courseId.toString();

              titleController.text = selectedCourse.courseName;
            } else {
              controller
                  .clear(); // Clear the text field if no course is selected
            }
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              // labelText: "Select Course",
              labelStyle: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
              hintText: "Select Course",
              hintStyle: const TextStyle(fontSize: 13),
              // labelStyle: const TextStyle(fontWeight: FontWeight.w500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),

              filled: true,
              fillColor: Colors.grey[100],
              // contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text("Error loading courses: $err"),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildReadOnlyBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(value, style: const TextStyle(fontSize: 13)),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Enroll Course",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
