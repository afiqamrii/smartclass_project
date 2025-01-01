import 'package:flutter/material.dart';
import '../models/class_models.dart';
import '../services/api.dart';

class LectUpdateClass extends StatefulWidget {
  final ClassModel classItem;

  const LectUpdateClass({Key? key, required this.classItem}) : super(key: key);

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

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
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
        title: const Text('Update Class'),
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
                  onTap: () => _pickDate(_dateController)),
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
                      id: widget.classItem.id,
                      courseCode: _courseCodeController.text,
                      courseName: _titleController.text,
                      date: _dateController.text,
                      startTime: _timeStartController.text,
                      endTime: _timeEndController.text,
                      location: _classLocationController.text,
                    );

                    await Api.updateClass(Api.baseUrl, updatedClass);

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
