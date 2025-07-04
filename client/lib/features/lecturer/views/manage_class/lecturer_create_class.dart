import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_show_all_classes.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/course_model.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/create_class_model.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/providers/course_providers.dart';
import 'package:smartclass_fyp_2024/shared/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/classroom_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classroom_models.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
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
  bool _isLoading = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _handleRefresh() async {
    // ignore: unused_local_variable
    final courseListAsync = ref.refresh(
        courseListByLecturerProvider(ref.watch(userProvider).externalId));

    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final courseListAsync =
        ref.watch(courseListByLecturerProvider(user.externalId));
    final classroomAsyncValue = ref.watch(classroomApiProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(context),
        body: SmartRefresher(
          onRefresh: _handleRefresh,
          enablePullDown: true,
          header: const ClassicHeader(
            releaseIcon: Icon(
              Icons.arrow_upward,
              color: Colors.grey,
            ),
          ),
          onLoading: _onLoading,
          controller: _refreshController,
          child: _createClassSection(
              context, user, courseListAsync, classroomAsyncValue),
        ),
        resizeToAvoidBottomInset: true);
  }

  Padding _createClassSection(
      BuildContext context,
      User user,
      AsyncValue<List<CourseModel>> courseListAsync,
      AsyncValue<List<ClassroomModels>> classroomAsyncValue) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 30.0,
        right: 30.0,
      ),
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

            const Text(
              'Select Classroom',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // Location Input
            classDropdown(
              context,
              classroomAsyncValue,
              locationController,
            ),
            // inputField(
            //   'Location',
            //   'e.g BK-01',
            //   25,
            //   null,
            //   textCapitalization: TextCapitalization.words,
            //   controller: locationController,
            // ),
            const SizedBox(height: 20),

            // Create Class Button
            Center(
              child: CustomButton(
                text: "Saves Class",
                icon: Icons.check,
                isLoading: _isLoading,
                onTap: () async {
                  setState(() {
                    _isSubmitted = true;
                  });

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

                  setState(() {
                    _isLoading = true;
                  });

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

                  setState(() {
                    _isLoading = false;
                  });

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
                  } else if (response == null) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text:
                          "You already have a class for this day at the specified time. Please choose a different time or day.",
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                      },
                    );
                  }
                },
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
      backgroundColor: Colors.white,
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
            toRightTransition(
              const LectViewAllClass(),
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
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
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

//Class Dropdown
Widget classDropdown(
  BuildContext context,
  AsyncValue<List<ClassroomModels>> classListAsync,
  TextEditingController locationController,
) {
  return classListAsync.when(
    data: (classrooms) {
      if (classrooms.isEmpty) {
        return const Text("No classrooms available.");
      }

      return DropdownSearch<ClassroomModels>(
        asyncItems: (String filter) async {
          final filtered = classrooms
              .where((c) =>
                  c.classroomName.toLowerCase().contains(filter.toLowerCase()))
              .toList();

          // Sort filtered classrooms by name
          filtered.sort((a, b) => a.classroomName
              .toLowerCase()
              .compareTo(b.classroomName.toLowerCase()));

          return filtered;
        },
        popupProps: PopupProps.dialog(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "Search classroom...",
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
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  item.classroomName,
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
        itemAsString: (classroom) => classroom.classroomName,
        onChanged: (selectedClassroom) {
          if (selectedClassroom != null) {
            locationController.text = selectedClassroom.classroomId.toString();
          } else {
            locationController.clear();
          }
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: "Select Classroom",
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      );
    },
    loading: () => const CircularProgressIndicator(),
    error: (err, _) => Text("Error loading classrooms: $err"),
  );
}

//Course Dropdown
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
            padding: const EdgeInsets.symmetric(horizontal: 13),
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
                    color: Colors.black,
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
            hintText: "Select a course",
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
            // contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      );
    },
    loading: () => const CircularProgressIndicator(),
    error: (err, _) => Text("Error loading courses: $err"),
  );
}
