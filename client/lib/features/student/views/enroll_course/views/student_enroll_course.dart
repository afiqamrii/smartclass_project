import 'package:another_flushbar/flushbar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/course_model.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/providers/course_providers.dart';
import 'package:smartclass_fyp_2024/features/student/views/enroll_course/services/student_course_enrollment_services.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';

class StudentEnrollCourse extends ConsumerStatefulWidget {
  const StudentEnrollCourse({super.key});

  @override
  ConsumerState<StudentEnrollCourse> createState() =>
      _StudentEnrollCourseState();
}

class _StudentEnrollCourseState extends ConsumerState<StudentEnrollCourse> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  CourseModel? _selectedCourse;
  final TextEditingController courseController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _enrollCourse(String studentId, int courseId, String courseName,
      String lecturerId, String lecturerEmail) async {
    setState(() => isLoading = true);

    // Call the service to enroll the course
    await CourseEnrollmentService.enrollCourse(
      context,
      courseId,
      studentId.toString(),
      courseName,
      lecturerId,
      lecturerEmail, // Get email from user provider
      ref.read(userProvider).userEmail,
    );

    // After enrollment, clear the controllers
    setState(() => isLoading = false);
  }

  void _onRefresh() async {
    // ignore: unused_result
    ref.refresh(courseListStudentProvider(ref.read(userProvider).externalId.toString()));
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
    final courseListAsync = ref.watch(courseListStudentProvider(user.externalId.toString()));

    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const ClassicHeader(
          releaseIcon: Icon(
            Icons.arrow_upward,
            color: Colors.grey,
          ),
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: courseListAsync.when(
            data: (courses) => Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildLabel('Student Name'),
                  const SizedBox(height: 10),
                  _buildReadOnlyBox(user.name),
                  const SizedBox(height: 20),
                  _buildLabel('Student ID'),
                  const SizedBox(height: 10),
                  _buildReadOnlyBox(user.externalId.toString()),
                  const SizedBox(height: 20),
                  _buildLabel('Select Course'),
                  const SizedBox(height: 10),
                  courseDropdown(
                    context,
                    courseListAsync,
                    courseController,
                    titleController,
                  ),
                  const SizedBox(height: 30),
                  // Enroll button
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (courseController.text.isEmpty) {
                              Flushbar(
                                message: 'Please select a course to enroll.',
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.red.shade600,
                                margin: const EdgeInsets.all(8),
                                borderRadius: BorderRadius.circular(8),
                                flushbarPosition: FlushbarPosition.TOP,
                                icon: const Icon(Icons.error,
                                    color: Colors.white),
                              ).show(context);
                              return;
                            }

                            // Confirmation dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => _buildConfirmationDialog(
                                  context, user, courseListAsync),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primaryColor,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: ColorConstants.primaryColor,
                              size: 25,
                            ),
                          )
                        : const Text(
                            'Enroll Course',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                Center(child: Text('Error loading courses: $err')),
          ),
        ),
      ),
    );
  }

  Dialog _buildConfirmationDialog(BuildContext context, User user,
      AsyncValue<List<CourseModel>> courseListAsync) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Colors.blueAccent,
              size: 40,
            ),
            const SizedBox(height: 16),
            const Text(
              'Confirm Enrollment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to enroll for',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              '"${titleController.text}"',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (_formKey.currentState!.validate() &&
                          _selectedCourse != null) {
                        _enrollCourse(
                            user.externalId,
                            _selectedCourse!.courseId,
                            _selectedCourse!.courseName,
                            _selectedCourse!.lecturerId,
                            _selectedCourse!.lecturerEmail);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Enroll',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget courseDropdown(
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
                hintStyle: const TextStyle(fontSize: 14),
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
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${item.lecturerName} | ${item.lecturerEmail}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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
              _selectedCourse = selectedCourse; // store selected course
              controller.text = selectedCourse.courseId.toString();
              titleController.text = selectedCourse.courseName;
            } else {
              _selectedCourse = null;
              controller.clear();
              titleController.clear();
            }
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              // labelText: "Select Course",
              labelStyle: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
              hintText: "Select Course",
              hintStyle: const TextStyle(fontSize: 13),
              // labelStyle: const TextStyle(fontWeight: FontWeight.w500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
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

  InputDecoration inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildReadOnlyBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(value, style: const TextStyle(fontSize: 13)),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Enroll Course",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
