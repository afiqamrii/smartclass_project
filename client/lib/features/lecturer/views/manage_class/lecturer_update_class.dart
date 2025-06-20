import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_view_class.dart';
import 'package:smartclass_fyp_2024/shared/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import '../../../../shared/data/models/class_models.dart';
import '../../../../shared/data/services/classApi.dart';

class LectUpdateClass extends ConsumerStatefulWidget {
  final ClassCreateModel classItem;

  const LectUpdateClass({super.key, required this.classItem});

  @override
  ConsumerState<LectUpdateClass> createState() => _LectUpdateClassState();
}

class _LectUpdateClassState extends ConsumerState<LectUpdateClass> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _courseCodeController;
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _timeStartController;
  late TextEditingController _timeEndController;
  late TextEditingController _classLocationController;
  late TextEditingController _mergedCourseInfoController;

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

    _mergedCourseInfoController = TextEditingController(
      text: "${widget.classItem.courseCode} - ${widget.classItem.courseName}",
    );
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
    _mergedCourseInfoController.dispose();
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
      builder: (BuildContext context, Widget? child) {
        // Wrap with MediaQuery to force 12-hour format
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text =
          picked.format(context); // This will now return 12-hour format
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Class',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
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
                  size: 18,
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
              _buildInputField(
                'Class Name',
                '',
                null,
                null,
                controller: _mergedCourseInfoController,
                textCapitalization: TextCapitalization.none,
                readOnlyOverride: true,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                'Date',
                'Select a date',
                null,
                () => pickDate(context, _dateController),
                controller: _dateController,
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                'Time Start',
                'Enter start time',
                null,
                () => _pickTime(_timeStartController),
                controller: _timeStartController,
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                'Time End',
                'Enter end time',
                null,
                () => _pickTime(_timeEndController),
                controller: _timeEndController,
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                'Class Location',
                'Enter class location',
                null,
                null,
                controller: _classLocationController,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CustomButton(
                  onTap: () async {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: "Update Class",
                      text: "Are you sure you want to update this class?",
                      confirmBtnText: "Yes",
                      cancelBtnText: "No",
                      onConfirmBtnTap: () async {
                        if (_formKey.currentState!.validate()) {
                          final updatedClass = ClassCreateModel(
                            classId: widget.classItem.classId,
                            courseCode: _courseCodeController.text,
                            courseName: _titleController.text,
                            date: _dateController.text,
                            startTime: _timeStartController.text,
                            endTime: _timeEndController.text,
                            location: _classLocationController.text,
                            lecturerId: user.externalId,
                            imageUrl: "",
                          );

                          final response = await Api.updateClass(
                              ApiConstants.baseUrl, updatedClass);

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
                                    builder: (context) => LecturerViewClass(
                                        classItem: updatedClass),
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
                    );
                  },
                  text: "Update Class",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String placeholder,
    int? maxLength,
    VoidCallback? onTap, {
    TextEditingController? controller,
    required TextCapitalization textCapitalization,
    bool readOnlyOverride = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          readOnly: readOnlyOverride || onTap != null,
          textCapitalization: textCapitalization,
          onTap: onTap,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
