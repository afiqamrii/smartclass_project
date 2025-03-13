import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_view_class.dart';
import '../models/lecturer/class_models.dart';
import '../services/lecturer/classApi.dart';

class LectUpdateClass extends StatefulWidget {
  final ClassModel classItem;

  const LectUpdateClass({super.key, required this.classItem});

  @override
  State<LectUpdateClass> createState() => _LectUpdateClassState();
}

class _LectUpdateClassState extends State<LectUpdateClass> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _courseCodeController;
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _timeStartController;
  late TextEditingController _timeEndController;
  late TextEditingController _classLocationController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current class details
    _courseCodeController =
        TextEditingController(text: widget.classItem.courseCode);
    _titleController = TextEditingController(text: widget.classItem.courseName);
    _dateController = TextEditingController(text: widget.classItem.date);
    _timeStartController =
        TextEditingController(text: widget.classItem.startTime);
    _timeEndController = TextEditingController(text: widget.classItem.endTime);
    _classLocationController =
        TextEditingController(text: widget.classItem.location);
  }

  @override
  void dispose() {
    // Release the resources used by the controllers
    _courseCodeController.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _timeStartController.dispose();
    _timeEndController.dispose();
    _classLocationController.dispose();
    super.dispose();
  }

  Future<void> pickDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Format the selected date to "14 March 2025"
      String formattedDate = DateFormat('d MMMM yyyy').format(picked);
      controller.text = formattedDate;
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Class',
          style: TextStyle(fontSize: 18),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInputField('Course Code', _courseCodeController),
              const SizedBox(height: 16),
              _buildInputField('Title', _titleController),
              const SizedBox(height: 16),
              _buildInputField('Date', _dateController,
                  onTap: () => pickDate(context, _dateController)),
              const SizedBox(height: 16),
              _buildInputField('Time Start', _timeStartController,
                  onTap: () => _pickTime(_timeStartController)),
              const SizedBox(height: 16),
              _buildInputField('Time End', _timeEndController,
                  onTap: () => _pickTime(_timeEndController)),
              const SizedBox(height: 16),
              _buildInputField('Class Location', _classLocationController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedClass = ClassModel(
                      classId: widget.classItem.classId,
                      courseCode: _courseCodeController.text,
                      courseName: _titleController.text,
                      date: _dateController.text,
                      startTime: _timeStartController.text,
                      endTime: _timeEndController.text,
                      location: _classLocationController.text,
                    );

                    final response =
                        await Api.updateClass(Api.baseUrl, updatedClass);

                    //Show QuickAlert message for user if the update is error or success
                    if (response != null) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: 'Class updated successfully',
                        confirmBtnText: 'OK',
                        onConfirmBtnTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LecturerViewClass(classItem: updatedClass),
                            ),
                          );
                        },
                      );
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Failed to update class, try again!',
                        confirmBtnText: 'OK',
                        onConfirmBtnTap: () {
                          Navigator.pop(context);
                        },
                      );
                    }

                    // Navigator.pop(context);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //       content: Text('Class updated successfully')),
                    // );
                  }
                },
                child: const Text('Update Class'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
