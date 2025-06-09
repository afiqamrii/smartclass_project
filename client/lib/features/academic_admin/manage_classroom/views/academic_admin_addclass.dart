import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/models/create_classroom_mode.dart';
import 'package:smartclass_fyp_2024/features/academic_admin/manage_classroom/services/manage_classroom_api.dart';
import 'dart:io';

class AcademicAdminAddclass extends StatefulWidget {
  const AcademicAdminAddclass({super.key});

  @override
  State<AcademicAdminAddclass> createState() => _AcademicAdminAddclassState();
}

class _AcademicAdminAddclassState extends State<AcademicAdminAddclass> {
  final TextEditingController _classNameController = TextEditingController();
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

  void _addClassroom() async {
    final name = _classNameController.text.trim();
    if (name.isEmpty) {
      _showSnack('Classroom name cannot be empty', error: true);
      return;
    }

    if (!_isCamelCapital(name)) {
      _showSnack('Classroom name must follow Camel Capital format',
          error: true);
      return;
    }

    //Call Model & API to add classroom
    final classroomData = CreateClassroomMode(classroomName: name);

    //Call API
    await ManageClassroomApi.addClassroom(context, classroomData);

    // _classNameController.clear();
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
      final nameIndex = headers.indexWhere(
        (cell) =>
            cell?.value.toString().trim().toLowerCase() == 'classroom name',
      );

      if (nameIndex == -1) {
        _showSnack(
          'Missing required column: "Classroom Name". Make sure the column name is exactly like that.',
          error: true,
        );
        return;
      }

      extractedData.clear();
      for (int i = 1; i < sheet.rows.length; i++) {
        final value = sheet.rows[i][nameIndex]?.value.toString().trim() ?? '';
        extractedData.add({
          'classroomName': value,
          'valid': _isCamelCapital(value).toString(),
        });
      }

      setState(() {});
      _showSnack('Excel file parsed. Please review below.');
    }
  }

  void _updateClassroomName(int index, String newValue) {
    extractedData[index]['classroomName'] = newValue;
    extractedData[index]['valid'] = _isCamelCapital(newValue).toString();
    setState(() {});
  }

  void _confirmAllData() {
    final invalid = extractedData
        .where((e) => e['valid'] == 'false' || e['classroomName']!.isEmpty)
        .toList();

    if (invalid.isNotEmpty) {
      _showSnack('Please fix invalid entries before confirming.', error: true);
    } else {
      // TODO: send extractedData to backend or database
      _showSnack('All classroom names confirmed and saved.');
      extractedData.clear();
      selectedFileName = null;
      setState(() {});
    }
  }

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
            final isValid = item['valid'] == 'true';

            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: item['classroomName'],
                    onChanged: (value) => _updateClassroomName(index, value),
                    decoration: InputDecoration(
                      labelText: 'Classroom Name',
                      errorText:
                          isValid ? null : 'Invalid (Must be Camel Capital)',
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
          "Add Classroom",
          style: TextStyle(
            fontSize: 17,
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
              "Classroom Name",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _classNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'e.g., Bilik Kuliah 102',
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
                onPressed: _addClassroom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Add Classroom",
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
                    "• Only one column allowed\n"
                    "• Column name must be exactly: Classroom Name\n"
                    "• Each entry must use Camel Capital (e.g., Bilik Kuliah)",
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
