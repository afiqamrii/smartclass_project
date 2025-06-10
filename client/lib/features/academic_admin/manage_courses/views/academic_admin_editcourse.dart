import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/models/create_course_models.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/services/manage_course_api.dart';

class AcademicAdminEditcourse extends StatefulWidget {
  const AcademicAdminEditcourse(
      {super.key,
      required this.courseId,
      required this.courseCode,
      required this.courseName});
  final int courseId;
  final String courseCode;
  final String courseName;

  @override
  State<AcademicAdminEditcourse> createState() =>
      _AcademicAdminEditcourseState();
}

class _AcademicAdminEditcourseState extends State<AcademicAdminEditcourse> {
  late TextEditingController _courseCodeController;
  late TextEditingController _courseNameController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current class details
    _courseCodeController = TextEditingController(text: widget.courseCode);
    _courseNameController = TextEditingController(text: widget.courseName);
  }

  void _showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  //Method to add course
  void editCourse() async {
    final courseCode = _courseCodeController.text.trim();
    final courseName = _courseNameController.text.trim();

    if (courseCode.isEmpty || courseName.isEmpty) {
      _showSnack('Course code and name cannot be empty', error: true);
      return;
    }

    //Check if the current course name or course code is same as before edit
    if (courseCode == widget.courseCode && courseName == widget.courseName) {
      _showSnack('No changes made.', error: true);
      return;
    }

    final courseData = CreateCourseModels(
      courseCode: courseCode,
      courseName: courseName,
    );

    await ManageCourseApi.editCourse(
      context,
      courseData,
      widget.courseId,
    );

    // Optionally clear after success
    // _courseCodeController.clear();
    // _courseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Edit Course",
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Course Code",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _courseCodeController,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'e.g., CS101',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Course Name",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _courseNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'e.g., Computer Science',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    text: 'Are you sure you want to edit this course?',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    confirmBtnColor: Colors.black,
                    onConfirmBtnTap: () {
                      editCourse();
                      Navigator.pop(context);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Edit Course",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // const Divider(height: 40),
          ],
        ),
      ),
    );
  }
}
