import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_show_all_classes.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/class_models.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import '../../../../shared/data/services/classApi.dart';

class LectCreateClass extends ConsumerStatefulWidget {
  const LectCreateClass({super.key});

  @override
  ConsumerState<LectCreateClass> createState() => _LectCreateClassState();
}

class _LectCreateClassState extends ConsumerState<LectCreateClass> {
  // Controllers for text fields
  final courseCodeController = TextEditingController();
  final titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeStartController = TextEditingController();
  final TextEditingController timeEndController = TextEditingController();
  final locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    
    return Scaffold(
        appBar: appBar(context),
        body: _createClassSection(context, user),
        resizeToAvoidBottomInset: true);
  }

  Padding _createClassSection(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 50, top: 10),
        children: [
          //Here is the create class section , pass to the method inputField to create the input fields (title, description, date, time, location)
          // Subject Code Input
          inputField(
            'Course Code',
            'e.g : CSE3403',
            10,
            null,
            textCapitalization: TextCapitalization.characters,
            controller: courseCodeController,
          ),
          const SizedBox(height: 5),

          // Title Input
          inputField(
            'Class Name',
            'e.g : Programming (K1) , Max 50 words',
            50,
            null,
            textCapitalization: TextCapitalization.words,
            controller: titleController,
          ),
          const SizedBox(height: 5),

          // Date Input
          inputField(
            'Date',
            'e.g 20 October 2023',
            null,
            textCapitalization: TextCapitalization.none,
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
            textCapitalization: TextCapitalization.none,
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
            textCapitalization: TextCapitalization.none,
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
            25,
            null,
            textCapitalization: TextCapitalization.words,
            controller: locationController,
          ),
          const SizedBox(height: 5),

          // Create Class Button
          Center(
            
            child: ElevatedButton.icon(
              onPressed: () async {
                final classData = ClassCreateModel(
                  classId: 0,
                  courseCode: courseCodeController.text,
                  courseName: titleController.text,
                  date: dateController.text,
                  startTime: timeStartController.text,
                  endTime: timeEndController.text,
                  location: locationController.text,
                  lecturerId: user.externalId,  
                  imageUrl: "",
                );
                // var data = {
                //   'courseCode': courseCodeController.text,
                //   'className': titleController.text,
                //   'date': dateController.text,
                //   'timeStart': timeStartController.text,
                //   'timeEnd': timeEndController.text,
                //   'classLocation': locationController.text,
                // };

                final response = await Api.addClass(classData);

                if (response != null && response['Status_Code'] == 200) {
                  //Shows a success message using QuickAlert for create class is successfull
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
                  //Shows an error message using QuickAlert for create class is not successfull
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
      toolbarHeight: 60.0,
      backgroundColor: Colors.grey[100],
      title: const Text(
        'Create Class',
        style: TextStyle(
          fontSize: 19,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      leadingWidth: 90,
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LectViewAllClass(),
            ),
          );
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
      titleSpacing: 0,
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey[300]!,
          width: 1.0,
        ),
      ),
    );
  }

  // Input Field Widget
  Widget inputField(
      String label, String placeholder, int? maxLength, VoidCallback? onTap,
      {TextEditingController? controller,
      required TextCapitalization textCapitalization}) {
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
          readOnly: onTap != null,
          textCapitalization: textCapitalization,
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
      // Format the selected date to "14 March 2025"
      String formattedDate = DateFormat('d MMMM yyyy').format(picked);
      controller.text = formattedDate;
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
