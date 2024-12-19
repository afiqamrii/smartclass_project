import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/services/api.dart';

class LectCreateClass extends StatefulWidget {
  const LectCreateClass({super.key});

  @override
  State<LectCreateClass> createState() => _LectCreateClassState();
}

class _LectCreateClassState extends State<LectCreateClass> {
  // Controllers for text fields
  final courseCodeController = TextEditingController();
  final titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeStartController = TextEditingController();
  final TextEditingController timeEndController = TextEditingController();
  final locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: _createClassSection(context),
        resizeToAvoidBottomInset: false);
  }

  Padding _createClassSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject Code Input
          inputField('Course Code', 'e.g : CSE3403', null,
              controller: courseCodeController),
          const SizedBox(height: 20),

          // Title Input
          inputField('Title', 'e.g : Programming (K1) , Max 50 words', null,
              controller: titleController),
          const SizedBox(height: 20),

          // Date Input
          inputField(
            'Date',
            'e.g 20 October 2023',
            () => pickDate(context, dateController),
            controller: dateController,
          ),
          const SizedBox(height: 20),

          // Time Start Input
          inputField(
            'Time Start',
            'e.g 11.00 a.m',
            () => pickTime(context, timeStartController),
            controller: timeStartController,
          ),
          const SizedBox(height: 20),

          // Time End Input
          inputField(
            'Time End',
            'e.g 1.00 p.m',
            () => pickTime(context, timeEndController),
            controller: timeEndController,
          ),
          const SizedBox(height: 20),

          // Location Input
          inputField('Location', 'e.g BK-01', null,
              controller: locationController),
          const SizedBox(height: 20),

          // Create Class Button
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                var data = {
                  'courseCode': courseCodeController.text,
                  'title': titleController.text,
                  'date': dateController.text,
                  'timeStart': timeStartController.text,
                  'timeEnd': timeEndController.text,
                  'location': locationController.text,
                };

                Api.addClass(data);
              },
              icon: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              label: const Text(
                "Create Class",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff323232),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(54.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 35.0, vertical: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // App Bar Section
  AppBar appBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.0,
      backgroundColor: Colors.transparent,
      title: const Text(
        'Create Class',
        style: TextStyle(
          fontSize: 22,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      leadingWidth: 90,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              SizedBox(width: 5),
              Text(
                "Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      titleSpacing: 0,
    );
  }

  // Input Field Widget
  Widget inputField(String label, String placeholder, VoidCallback? onTap,
      {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: onTap != null,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  // Function to pick date
  Future<void> pickDate(
      BuildContext context, TextEditingController controller) async {
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

  // Function to pick time
  Future<void> pickTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }
}
