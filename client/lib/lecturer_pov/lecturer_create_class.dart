import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_show_all_classes.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_view_class.dart';
import '../services/api.dart';

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
      padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Here is the create class section , pass to the method inputField to create the input fields (title, description, date, time, location)
          // Subject Code Input
          inputField(
            'Course Code',
            'e.g : CSE3403',
            10,
            null,
            controller: courseCodeController,
          ),
          const SizedBox(height: 5),

          // Title Input
          inputField(
            'Title',
            'e.g : Programming (K1) , Max 50 words',
            50,
            null,
            controller: titleController,
          ),
          const SizedBox(height: 5),

          // Date Input
          inputField(
            'Date',
            'e.g 20 October 2023',
            null,
            () => pickDate(
              context,
              dateController,
            ),
            controller: dateController,
          ),
          const SizedBox(height: 20),

          // Time Start Input
          inputField(
            'Time Start',
            'e.g 11.00 a.m',
            null,
            () => pickTime(
              context,
              timeStartController,
            ),
            controller: timeStartController,
          ),
          const SizedBox(height: 20),

          // Time End Input
          inputField(
            'Time End',
            'e.g 1.00 p.m',
            null,
            () => pickTime(
              context,
              timeEndController,
            ),
            controller: timeEndController,
          ),
          const SizedBox(height: 20),

          // Location Input
          inputField(
            'Location',
            'e.g BK-01',
            30,
            null,
            controller: locationController,
          ),
          const SizedBox(height: 5),

          // Create Class Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                var data = {
                  'courseCode': courseCodeController.text,
                  'title': titleController.text,
                  'date': dateController.text,
                  'timeStart': timeStartController.text,
                  'timeEnd': timeEndController.text,
                  'location': locationController.text,
                };

                final response = await Api.addClass(data);

                if (response != null && response['Status_Code'] == 200) {
                  QuickAlert.show(
                    // ignore: use_build_context_synchronously
                    context: context,
                    type: QuickAlertType.success,
                    text: "Class Created Successfully",
                    onConfirmBtnTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LectViewAllClass()),
                      );
                    },
                  );
                } else {
                  QuickAlert.show(
                    // ignore: use_build_context_synchronously
                    context: context,
                    type: QuickAlertType.error,
                    text: "Missing Required Fields, Try Again!",
                    onConfirmBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                }
              },
              icon: const Icon(
                Icons.check,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              label: const Text(
                "Saves Class",
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
                    horizontal: 20.0, vertical: 12.0),
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
  Widget inputField(
      String label, String placeholder, int? maxLength, VoidCallback? onTap,
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
          maxLength: maxLength,
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
