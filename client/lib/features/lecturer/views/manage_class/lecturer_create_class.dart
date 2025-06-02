import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_show_all_classes.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/course_model.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/create_class_model.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/providers/course_providers.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import '../../../../shared/data/services/classApi.dart';

class LectCreateClass extends ConsumerStatefulWidget {
  const LectCreateClass({super.key});

  @override
  ConsumerState<LectCreateClass> createState() => _LectCreateClassState();
}

class _LectCreateClassState extends ConsumerState<LectCreateClass> {
  // Controllers for text fields
  CourseModel? selectedCourse;
  final TextEditingController courseController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeStartController = TextEditingController();
  final TextEditingController timeEndController = TextEditingController();
  final locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final courseListAsync = ref.watch(courseListProvider);

    return Scaffold(
        appBar: appBar(context),
        body: _createClassSection(context, user, courseListAsync),
        resizeToAvoidBottomInset: true);
  }

  Padding _createClassSection(BuildContext context, User user,
      AsyncValue<List<CourseModel>> courseListAsync) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Form(
        key: _formKey,
        autovalidateMode:
            _isSubmitted ? AutovalidateMode.always : AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 50, top: 10),
          children: [
            //Here is the create class section , pass to the method inputField to create the input fields (title, description, date, time, location)
            // Subject Code Input
            const Text(
              'Select Course',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _courseDropdown(
              context,
              courseListAsync,
              courseController,
              titleController,
            ),
            const SizedBox(height: 10),

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
                  // Basic validation
                  if (courseController.text.isEmpty ||
                      titleController.text.isEmpty ||
                      dateController.text.isEmpty ||
                      timeStartController.text.isEmpty ||
                      timeEndController.text.isEmpty ||
                      locationController.text.isEmpty) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text:
                          "All fields are required. Please fill in all the details.",
                    );
                    return;
                  }

                  final classData = CreateClassModel(
                    classId: 0,
                    courseId: int.parse(courseController.text),
                    className: titleController.text,
                    date: dateController.text,
                    startTime: timeStartController.text,
                    endTime: timeEndController.text,
                    location: locationController.text,
                    lecturerId: user.externalId,
                    imageUrl: "",
                  );

                  final response = await Api.addClass(classData);

                  if (response != null && response['Status_Code'] == 200) {
                    QuickAlert.show(
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
                      context: context,
                      type: QuickAlertType.error,
                      text: "Failed to create class. Try again!",
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
          fontSize: 15,
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
  Future<void> pickTime(TextEditingController controller) async {
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
}

Widget _courseDropdown(
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
                    fontSize: 16,
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
            controller.clear(); // Clear the text field if no course is selected
          }
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: "Select Course",
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
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
