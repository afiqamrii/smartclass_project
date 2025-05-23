import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/student/views/report_utility/services/student_report_service.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/classroom_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classroom_models.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';

class ReportUtilityPage extends ConsumerStatefulWidget {
  const ReportUtilityPage({super.key});

  @override
  ConsumerState<ReportUtilityPage> createState() => _ReportUtilityPageState();
}

class _ReportUtilityPageState extends ConsumerState<ReportUtilityPage> {
  final reportTitleController = TextEditingController();
  final reportDescriptionController = TextEditingController();
  final classroomController = TextEditingController();
  final int maxChars = 100;
  int charCount = 0;
  File? selectedImage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    reportDescriptionController.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    final text = reportDescriptionController.text;
    setState(() {
      charCount = text.length;
      if (charCount > maxChars) {
        final trimmed = text.substring(0, maxChars);
        reportDescriptionController.value = TextEditingValue(
          text: trimmed,
          selection: TextSelection.collapsed(offset: trimmed.length),
        );
        charCount = maxChars;
      }
    });
  }

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picked =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    setState(() {
                      selectedImage = File(picked.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      selectedImage = File(picked.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> submitReport(BuildContext context, String userId) async {
    setState(() {
      _isSubmitting = true;
    });

    // Validate the form fields
    String title = reportTitleController.text;
    String description = reportDescriptionController.text;
    int classroomId = int.tryParse(classroomController.text) ?? 0;

    try {
      await submitReports(
        context,
        title,
        description,
        userId,
        classroomId,
        selectedImage,
      );

      // // Optionally clear the form
      // reportTitleController.clear();
      // reportDescriptionController.clear();
      setState(() {
        selectedImage = null;
        charCount = 0;
      });
    } catch (e) {
      // Show error Flushbar
      Flushbar(
        message: 'Failed to submit report: $e',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade600,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
      ).show(context);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    reportTitleController.dispose();
    reportDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the user data from provider
    final user = ref.watch(userProvider);

    // Get the classroom list from provider
    final classroomList = ref.watch(classroomApiProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: _reportSection(context, user, classroomList),
    );
  }

  SingleChildScrollView _reportSection(BuildContext context, User user,
      AsyncValue<List<ClassroomModels>> classroomList) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Report Title
          const Text(
            "Report Title",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          TextFormField(
            controller: reportTitleController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: "e.g : Lamp not working",
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a title' : null,
          ),

          const SizedBox(height: 20),

          // Choose Classroom
          const Text(
            "Choose Classroom",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          // Choose Classroom
          _classroomDropdown(context, classroomList, classroomController),

          const SizedBox(height: 20),

          // Report Description
          const Text(
            "Report Description",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          TextFormField(
            controller: reportDescriptionController,
            maxLines: null,
            minLines: 5,
            decoration: InputDecoration(
              hintText: "e.g : Lamp not working in BK103 classroom",
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const SizedBox(height: 5),

          // Character count
          // Display character count below the text field
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "$charCount / $maxChars characters",
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 10),

          // Image Picker UI
          const Text(
            "Upload Image",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(selectedImage!,
                          fit: BoxFit.cover, width: double.infinity),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate,
                              size: 40, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("Tap to upload image",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 30),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => submitReport(context, user.externalId),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSubmitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send, size: 15),
                        SizedBox(width: 8),
                        Text(
                          "Submit Report",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Create Report Issues",
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

  Widget _classroomDropdown(
      BuildContext context,
      AsyncValue<List<ClassroomModels>> classroomList,
      TextEditingController controller) {
    return classroomList.when(
      data: (courses) {
        if (courses.isEmpty) {
          return const Text("No classroom available.");
        }

        return DropdownSearch<ClassroomModels>(
          asyncItems: (String filter) async {
            return courses
                .where((course) => course
                    .toString()
                    .toLowerCase()
                    .contains(filter.toLowerCase()))
                .toList();
          },
          popupProps: PopupProps.dialog(
            fit: FlexFit.tight,
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search classroom...",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          onChanged: (selectedClassroom) {
            if (selectedClassroom != null) {
              controller.text = selectedClassroom.classroomId.toString();
            } else {
              controller.clear();
            }
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: "e.g : BK103",
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
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
      error: (err, _) => Text("Error loading courses: $err"),
    );
  }
}
