import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/models/create_course_models.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_courses/services/manage_course_api.dart';

class AcademicAdminAddcourse extends StatefulWidget {
  const AcademicAdminAddcourse({super.key});

  @override
  State<AcademicAdminAddcourse> createState() => _AcademicAdminAddcourseState();
}

class _AcademicAdminAddcourseState extends State<AcademicAdminAddcourse> {
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();
  String? selectedFileName;
  List<Map<String, String>> extractedData = []; // List to store Excel rows

  void _showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  bool _isCamelCapital(String name) {
    final regex = RegExp(r'^([A-Z][a-zA-Z0-9]*)(\s([A-Z][a-zA-Z0-9]*|\d+))*$');
    return regex.hasMatch(name);
  }

  //Method to add course
  void _addCourse() async {
    final courseCode = _courseCodeController.text.trim();
    final courseName = _courseNameController.text.trim();

    if (courseCode.isEmpty || courseName.isEmpty) {
      _showSnack('Course code and name cannot be empty', error: true);
      return;
    }

    if (!_isCamelCapital(courseName)) {
      _showSnack('Course name must follow Camel Capital format', error: true);
      return;
    }

    final courseData = CreateCourseModels(
      courseCode: courseCode,
      courseName: courseName,
    );

    await ManageCourseApi.addCourse(
      context,
      courseData,
    );

    // Optionally clear after success
    // _courseCodeController.clear();
    // _courseNameController.clear();
  }

  Future<void> _pickExcelFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      selectedFileName = result.files.single.name;
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final excelFile = Excel.decodeBytes(bytes);

      final sheet = excelFile.tables[excelFile.tables.keys.first];
      if (sheet == null) {
        _showSnack('Excel file is empty or invalid.', error: true);
        return;
      }

      final headers = sheet.rows.first;
      final nameIndex = headers.indexWhere((cell) =>
          cell?.value.toString().trim().toLowerCase() == 'course name');
      final codeIndex = headers.indexWhere((cell) =>
          cell?.value.toString().trim().toLowerCase() == 'course code');

      if (nameIndex == -1 || codeIndex == -1) {
        _showSnack(
          'Missing required columns: "Course Name" and/or "Course Code".',
          error: true,
        );
        return;
      }

      // Clear extractedData before adding new data
      extractedData.clear();

      // Extract data from Excel
      // Skip the first row (headers)
      // Loop through the remaining rows
      for (int i = 1; i < sheet.rows.length; i++) {
        final name = sheet.rows[i][nameIndex]?.value.toString().trim() ?? '';
        final code = sheet.rows[i][codeIndex]?.value.toString().trim() ?? '';
        extractedData.add({
          'courseName': name,
          'courseCode': code,
          'valid': _isCamelCapital(name).toString(),
        });
      }

      setState(() {});
      _showSnack('Excel file parsed. Please review below.');
    }
  }

  //Method to confirm all data
  void _confirmAllData() {
    final invalid = extractedData
        .where((e) =>
            e['valid'] == 'false' ||
            (e['courseName']?.isEmpty ?? true) ||
            (e['courseCode']?.isEmpty ?? true))
        .toList();

    if (invalid.isNotEmpty) {
      _showSnack('Please fix invalid entries before confirming.', error: true);
    } else {
      // TODO: send to backend
      _showSnack('All course data confirmed and saved.');
      extractedData.clear();
      selectedFileName = null;
      setState(() {});
    }
  }

  //Method to build Excel table

  Widget _buildExcelTable() {
    if (extractedData.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 30),
        const Text("Review & Edit Extracted Data:",
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: extractedData.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final item = extractedData[index];
            final isNameValid = _isCamelCapital(item['courseName'] ?? '');
            final isCodeValid =
                item['courseCode'] != null && item['courseCode']!.isNotEmpty;
            final isValid = isNameValid && isCodeValid;

            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: item['courseName'],
                    onChanged: (value) {
                      extractedData[index]['courseName'] = value.trim();
                      extractedData[index]
                          ['valid'] = (_isCamelCapital(value.trim()) &&
                              (extractedData[index]['courseCode']?.isNotEmpty ??
                                  false))
                          .toString();
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'Course Name',
                      errorText: isNameValid ? null : 'Invalid format',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: item['courseCode'],
                    onChanged: (value) {
                      extractedData[index]['courseCode'] = value.trim();
                      extractedData[index]['valid'] = (_isCamelCapital(
                                  extractedData[index]['courseName'] ?? '') &&
                              value.trim().isNotEmpty)
                          .toString();
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'Course Code',
                      errorText: isCodeValid ? null : 'Cannot be empty',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  isValid ? Icons.check_circle : Icons.error,
                  color: isValid ? Colors.green : Colors.red,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: _confirmAllData,
            label: const Text('Confirm and Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Add Course",
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
            const Text(
              "Course Code",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _courseCodeController,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'e.g., CS101',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Course Name",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _courseNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'e.g., Computer Science',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addCourse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Add Course",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(height: 40),
            const Text(
              "Bulk Add via Excel",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "• Upload .xlsx or .xls file\n"
                    "• Only two column allowed\n"
                    "• Column name must be exactly: Course Name and Course Code\n"
                    "• Each entry must use Camel Capital (e.g., Internet Programming)",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: _pickExcelFile,
                    icon: const Icon(Icons.upload_file_rounded, size: 20),
                    label: Text(selectedFileName ?? 'Choose Excel File'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[100],
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    selectedFileName != null
                        ? 'Selected: $selectedFileName'
                        : 'No file selected',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            _buildExcelTable(),
          ],
        ),
      ),
    );
  }
}
