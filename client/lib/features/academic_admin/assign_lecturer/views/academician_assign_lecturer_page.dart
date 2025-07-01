import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/assign_lecturer/providers/assign_lecturer_provider.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/assign_lecturer/services/assign_lecturer_api.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/models/user_models.dart';

class AssignLecturerPage extends ConsumerStatefulWidget {
  final int courseId;
  final String courseName;
  final String courseCode;

  const AssignLecturerPage({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.courseCode,
  });

  @override
  ConsumerState<AssignLecturerPage> createState() => _AssignLecturerPageState();
}

class _AssignLecturerPageState extends ConsumerState<AssignLecturerPage> {
  String? selectedLecturerId;

  Future<void> assignLecturer(
    String lecturerId,
    BuildContext context,
    int courseId,
    String courseName,
    String courseCode,
    String lecturerEmail,
  ) async {
    // Call api to assign lecturer
    await AssignLecturerApi.assignLecturer(
      courseId,
      lecturerId,
      courseName,
      lecturerEmail,
      courseCode,
      context,
    );

    // Refresh the lecturers list
    ref.invalidate(assignLecturerProvider(widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    final lecturersAsync = ref.watch(assignLecturerProvider(widget.courseId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: lecturersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No registered lecturers found for now. Please try again later.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (lecturers) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Course Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 18,
                    bottom: 18,
                    right: 15,
                    left: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.courseName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select a lecturer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                // Dropdown to select lecturer
                DropdownSearch<UserModels>(
                  items: lecturers,
                  selectedItem: lecturers.firstWhere(
                    // ignore: unrelated_type_equality_checks
                    (lect) => lect.externalId == selectedLecturerId,
                    orElse: () => UserModels(
                      userId: 0,
                      userName: '',
                      name: 'Select a lecturer',
                      userEmail: '',
                      roleId: 0,
                      roleName: '',
                      externalId: '',
                      user_picture_url: '',
                      status: '',
                    ),
                  ),
                  itemAsString: (lect) => lect.name,
                  onChanged: (selectedLect) {
                    setState(() {
                      selectedLecturerId = selectedLect?.externalId;
                    });
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Select a lecturer",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 17,
                      ),
                    ),
                  ),
                  popupProps: PopupProps.dialog(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Search lecturer...",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
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
                            item.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
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
                ),
                // --- End DropdownSearch ---
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: selectedLecturerId == null
                          ? null
                          : () {
                              final selectedLecturer = lecturers.firstWhere(
                                (lect) => lect.externalId == selectedLecturerId,
                                orElse: () => UserModels(
                                  userId: 0,
                                  userName: '',
                                  name: '',
                                  userEmail: '',
                                  roleId: 0,
                                  roleName: '',
                                  externalId: '',
                                  user_picture_url: '',
                                  status: '',
                                ),
                              );

                              // Check if found
                              if (selectedLecturer.userId != 0) {
                                assignLecturer(
                                  selectedLecturerId!,
                                  context,
                                  widget.courseId,
                                  widget.courseName,
                                  widget.courseCode,
                                  selectedLecturer.userEmail,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please select a valid lecturer',
                                    ),
                                  ),
                                );
                              }
                            },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white, // set icon color to white
                      ),
                      label: const Text(
                        'Assign Lecturer',
                        style: TextStyle(
                          color: Colors.white,
                        ), // set label color to white
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: selectedLecturerId == null
                            ? Colors.grey
                            : ColorConstants.primaryColor,
                        foregroundColor: Colors
                            .white, // this sets the default text & icon color to white
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

AppBar _appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: const Text(
      "Assign Lecturer",
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
  );
}
