// ignore_for_file: unused_result

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/shared/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/summarization_models.dart';
import 'package:smartclass_fyp_2024/shared/data/services/summarizationApi.dart';

class LectuerViewTranscription extends ConsumerStatefulWidget {
  const LectuerViewTranscription({super.key, required this.classId});
  final int classId;

  @override
  ConsumerState<LectuerViewTranscription> createState() =>
      _LectuerViewTranscriptionState();
}

class _LectuerViewTranscriptionState
    extends ConsumerState<LectuerViewTranscription> {
  final TextEditingController _promptController = TextEditingController();
  bool _isSummarizing = false;
  bool _isRefreshing = false;
  String? _selectedSavedPrompt;

  // Handles the save prompt operation
  Future<void> _handleSavePrompt() async {
    final lecturerId = ref.read(userProvider).externalId;
    final promptToSave = _promptController.text.trim();

    if (promptToSave.isEmpty) return;

    try {
      await Summarizationapi.savePrompt(lecturerId, promptToSave);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Prompt saved successfully!',
      );
      ref.refresh(savedPromptsProvider); // refresh list
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to save prompt: $e',
      );
    }
  }

  // Handles the refresh operation
  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    ref.refresh(savedPromptsProvider);
    ref.invalidate(classDataProviderSummarization(widget.classId));
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isRefreshing = false);
  }

  // Handles the summarization API call
  Future<void> _handleSummarize(SummarizationModels transcriptionData) async {
    setState(() {
      _isSummarizing = true;
    });

    try {
      // Use custom prompt if provided, otherwise it will be null (backend uses default)
      final String? customPrompt =
          _promptController.text.isNotEmpty ? _promptController.text : null;

      // Call the API to generate the summary
      await Summarizationapi.summarizeText(
        transcriptionText: transcriptionData.transcriptionText,
        recordingId: transcriptionData.recordingId,
        classId: transcriptionData.classId,
        prompt: customPrompt,
      );

      // Show success message
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text:
              'Summarization complete! Pull down to refresh and view the summary.',
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            _handleRefresh(); // Refresh data automatically
          },
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Failed to generate summary: ${e.toString()}',
        );
      }
    } finally {
      setState(() {
        _isSummarizing = false;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsyncValue =
        ref.watch(classDataProviderSummarization(widget.classId));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transcription Summary",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 21, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: dataAsyncValue.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text("No transcription found."));
          }

          final transcriptionData = data[0];

          return LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            color: Colors.deepPurple,
            height: 100,
            animSpeedFactor: 2,
            backgroundColor: Colors.deepPurple[200],
            showChildOpacityTransition: false,
            child: Skeletonizer(
              enabled: _isRefreshing,
              effect: const ShimmerEffect(),
              child: ListView(
                children: [
                  const SizedBox(height: 15),
                  _sectionHeader("Transcription Results"),
                  _contentCard(transcriptionData.transcriptionText),
                  const SizedBox(height: 20),
                  _sectionHeader("Choose or Write Prompt"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Saved prompts dropdown
                        Consumer(
                          builder: (context, ref, _) {
                            final promptsAsync =
                                ref.watch(savedPromptsProvider);

                            return promptsAsync.when(
                              data: (prompts) {
                                return SizedBox(
                                  width: double.infinity, // prevent overflow
                                  child: DropdownSearch<String>(
                                    items: prompts
                                        .map((e) => e.summaryPrompt)
                                        .toList(),
                                    selectedItem: _selectedSavedPrompt,
                                    popupProps: PopupProps.dialog(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        decoration: InputDecoration(
                                          hintText: "Search prompt...",
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      dialogProps: DialogProps(
                                        contentPadding: const EdgeInsets.all(5),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 10,
                                      ),
                                      itemBuilder:
                                          (context, item, isSelected) =>
                                              Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 13,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 15),
                                            Text(
                                              item,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Divider(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              height: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Saved Prompts",
                                        labelStyle: const TextStyle(
                                          fontSize: 13,
                                        ),
                                        hintText: "Select or search prompt",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSavedPrompt = value;
                                        _promptController.text = value ?? '';
                                      });
                                    },
                                  ),
                                );
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (error, _) =>
                                  Text('Error loading prompts: $error'),
                            );
                          },
                        ),

                        const SizedBox(height: 10),
                        // Custom prompt input
                        TextField(
                          controller: _promptController,
                          decoration: const InputDecoration(
                            hintText:
                                'Enter custom prompt e.g. "Summarize this"',
                            hintStyle: TextStyle(
                              fontSize: 13,
                            ),
                            labelText:
                                'Or enter new prompt e.g. "Summarize this"',
                            labelStyle: TextStyle(
                              fontSize: 13,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: 10),
                        // Save button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.check,
                              size: 18,
                            ),
                            label: const Text(
                              'Save Prompt',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: 'FigtreeRegular',
                              ),
                            ),
                            onPressed: _handleSavePrompt,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: CustomButton(
                      onTap: () => _handleSummarize(transcriptionData),
                      text: 'Generate Summary',
                      isLoading: _isSummarizing,
                      icon: Icons.auto_awesome,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (transcriptionData.summaryText.isNotEmpty) ...[
                    _sectionHeader("Generated Summary"),
                    _contentCard(transcriptionData.summaryText),
                  ],
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
        error: (err, _) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _contentCard(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 3,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'FigtreeRegular',
                height: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
