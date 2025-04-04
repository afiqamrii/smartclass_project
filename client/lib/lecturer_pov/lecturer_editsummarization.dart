import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_viewSummarization.dart';
import 'package:smartclass_fyp_2024/services/lecturer/summarizationApi.dart';

class LecturerEditsummarization extends StatefulWidget {
  final List<String> summarizationData;
  final int summarizationClassId;

  const LecturerEditsummarization(
      {super.key,
      required this.summarizationData,
      required this.summarizationClassId});

  @override
  // ignore: library_private_types_in_public_api
  _LecturerEditsummarizationState createState() =>
      _LecturerEditsummarizationState();
}

class _LecturerEditsummarizationState extends State<LecturerEditsummarization> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.summarizationData.join('\n'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Summarization",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Padding(
            padding: EdgeInsets.only(left: 9.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 21,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // Save or handle edited text
              final editedText = _controller.text;

              // Update the text into the database
              final isSuccess = await Summarizationapi.updateSummarization(
                  widget.summarizationClassId, editedText);

              // Show Quickalert message for user if the update is successful or not
              if (isSuccess) {
                QuickAlert.show(
                  // ignore: use_build_context_synchronously
                  context: context,
                  type: QuickAlertType.success,
                  text: 'Class updated successfully',
                  confirmBtnText: 'OK',
                  onConfirmBtnTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LecturerViewsummarization(
                            classId: widget.summarizationClassId),
                      ),
                    );
                  },
                );
              } else {
                QuickAlert.show(
                  // ignore: use_build_context_synchronously
                  context: context,
                  type: QuickAlertType.error,
                  text: 'Failed to update class, try again!',
                  confirmBtnText: 'OK',
                  onConfirmBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 7,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: EditableTextWidget(
                controller: _controller,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditableTextWidget extends StatelessWidget {
  final TextEditingController controller;

  const EditableTextWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      style: const TextStyle(
        fontSize: 12.5,
        height: 1.6, // Adjust line height for readability
        color: Colors.black87,
      ),
    );
  }
}
