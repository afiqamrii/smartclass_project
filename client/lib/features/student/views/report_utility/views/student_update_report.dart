import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/views/report_pic_fullscreen.dart';
import 'package:smartclass_fyp_2024/features/student/views/report_utility/services/student_report_service.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/classroom_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classroom_models.dart';

class StudentUpdateReport extends ConsumerStatefulWidget {
  final int reportId;
  final String issueTitle;
  final String issueDescription;
  final String userId;
  final String issueStatus;
  final String imageUrl;
  final int classroomId;
  final String userName;
  final String classroomName;
  final String createdAt;

  const StudentUpdateReport({
    super.key,
    required this.reportId,
    required this.issueTitle,
    required this.issueDescription,
    required this.userId,
    required this.issueStatus,
    required this.imageUrl,
    required this.classroomId,
    required this.userName,
    required this.classroomName,
    required this.createdAt,
  });

  @override
  ConsumerState<StudentUpdateReport> createState() =>
      _StudentUpdateReportState();
}

class _StudentUpdateReportState extends ConsumerState<StudentUpdateReport> {
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
    reportTitleController.text = widget.issueTitle;
    reportDescriptionController.text = widget.issueDescription;
    classroomController.text = widget.classroomId.toString();
    charCount = widget.issueDescription.length;
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
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> submitReport(
      BuildContext context, String userId, String currentImageUrl) async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await updateReports(
        context,
        widget.reportId,
        reportTitleController.text,
        reportDescriptionController.text,
        userId,
        int.tryParse(classroomController.text) ?? 0,
        selectedImage,
        currentImageUrl,
      );

      setState(() {
        selectedImage = null;
        charCount = 0;
      });
    } catch (e) {
      Flushbar(
        message: 'Failed to update report: $e',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade600,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
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
    classroomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final classroomList = ref.watch(classroomApiProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextLabel("Report Title"),
            const SizedBox(height: 10),
            _buildTextField(reportTitleController, "e.g: Lamp not working"),
            const SizedBox(height: 20),
            _buildTextLabel("Choose Classroom"),
            const SizedBox(height: 10),
            _classroomDropdown(context, classroomList, classroomController),
            const SizedBox(height: 20),
            _buildTextLabel("Report Description"),
            const SizedBox(height: 10),
            _buildDescriptionField(),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "$charCount / $maxChars characters",
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextLabel("Current Image (Tap to view)"),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        FullscreenImageViewer(imageUrl: widget.imageUrl),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imageUrl,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextLabel("Upload New Image (Optional)"),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate,
                                size: 30, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              "Tap to upload image",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    submitReport(context, user.externalId, widget.imageUrl),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white, size: 25)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, size: 15),
                          SizedBox(width: 8),
                          Text("Update Report"),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Update Report",
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

  Widget _buildTextLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: reportDescriptionController,
      maxLines: null,
      minLines: 5,
      decoration: InputDecoration(
        hintText: "e.g : Lamp not working in BK103 classroom",
        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _classroomDropdown(
    BuildContext context,
    AsyncValue<List<ClassroomModels>> classroomList,
    TextEditingController controller,
  ) {
    return classroomList.when(
      data: (classrooms) {
        if (classrooms.isEmpty) {
          return const Text("No classroom available.");
        }

        // Find the initial classroom based on controller.text (classroomId)
        final initialClassroom = classrooms.firstWhere(
          (c) => c.classroomId.toString() == controller.text,
          orElse: () => classrooms.first,
        );

        return DropdownSearch<ClassroomModels>(
          items: classrooms,
          selectedItem: initialClassroom,
          itemAsString: (ClassroomModels c) => c.classroomName,
          onChanged: (ClassroomModels? selected) {
            if (selected != null) {
              controller.text = selected.classroomId.toString();
            }
          },
          popupProps: PopupProps.dialog(
            fit: FlexFit.tight,
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search classroom...",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: "Select a classroom",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text('Error loading classrooms: $err'),
    );
  }
}
