import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/student/views/report_utility/services/report_service.dart';

class ReportUtilityPage extends ConsumerStatefulWidget {
  const ReportUtilityPage({super.key});

  @override
  ConsumerState<ReportUtilityPage> createState() => _ReportUtilityPageState();
}

class _ReportUtilityPageState extends ConsumerState<ReportUtilityPage> {
  final reportTitleController = TextEditingController();
  final reportDescriptionController = TextEditingController();
  final int maxChars = 100;
  int charCount = 0;
  File? selectedImage;

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

  Future<void> submitReport(BuildContext context) async {
    String title = reportTitleController.text;
    String description = reportDescriptionController.text;

    // Call submitReport function from report_service.dart
    await submitReports(
      context,
      title,
      description,
      selectedImage,
    );
  }

  @override
  void dispose() {
    reportTitleController.dispose();
    reportDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Report Issues",
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
      ),
      body: SingleChildScrollView(
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
              decoration: InputDecoration(
                hintText: "e.g : Lamp not working",
                hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a title'
                  : null,
            ),

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
              "Upload Image (optional)",
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
                  color: Colors.grey.shade100,
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
              child: ElevatedButton.icon(
                onPressed: () => submitReport(context),
                icon: const Icon(
                  Icons.send,
                  size: 15,
                ),
                label: const Text(
                  "Submit Report",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
