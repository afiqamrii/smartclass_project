import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/models/create_classroom_mode.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/services/manage_classroom_api.dart';

class AcademicAdminEditclassroom extends StatefulWidget {
  const AcademicAdminEditclassroom({
    super.key,
    required this.classId,
    required this.className,
  });

  final int classId;
  final String className;

  @override
  State<AcademicAdminEditclassroom> createState() =>
      _AcademicAdminEditclassroomState();
}

class _AcademicAdminEditclassroomState
    extends State<AcademicAdminEditclassroom> {
  late TextEditingController _classNameController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current class details
    _classNameController = TextEditingController(text: widget.className);
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
  void editClassroom() async {
    final className = _classNameController.text.trim();

    if (className.isEmpty) {
      _showSnack('Classroom name cannot be empty', error: true);
      return;
    }

    //Check if the current course name or course code is same as before edit
    if (className == widget.className) {
      _showSnack('No changes made.', error: true);
      return;
    }

    final classData = CreateClassroomMode(classroomName: className);

    //Call API
    await ManageClassroomApi.editClassroom(
      context,
      classData,
      widget.classId,
    );

    // Optionally clear after success
    // _classNameController.clear();
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
              "Classroom Name",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _classNameController,
              textCapitalization: TextCapitalization.words,
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
                      editClassroom();
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
                  "Edit Classroom",
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
