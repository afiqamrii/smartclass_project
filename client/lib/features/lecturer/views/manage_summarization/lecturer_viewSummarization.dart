import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/shared/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_summarization/lecturer_editsummarization.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/template/lecturer_bottom_navbar.dart';
import 'package:smartclass_fyp_2024/shared/data/services/summarizationApi.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class LecturerViewsummarization extends ConsumerStatefulWidget {
  const LecturerViewsummarization({super.key, required this.classId});
  final int classId; //ClassId to get the data from the previous page

  //Constructor to get the classId from the previous page
  @override
  ConsumerState<LecturerViewsummarization> createState() =>
      _LecturerViewsummarizationState();
}

class _LecturerViewsummarizationState
    extends ConsumerState<LecturerViewsummarization> {
  bool _isRefreshing = false; // Flag to track refresh state

  //Handle refresh and reload the data from data providero
  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() {
      _isRefreshing = true; // Set the refreshing state to true
    });
    // Perform the refresh operation
    //Reload the daaata from provider
    // ignore: unused_result, await_only_futures
    await ref.read(classDataProviderSummarization(widget.classId).future);
    //reloading take some time..
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isRefreshing = false; // Set the refreshing state to false
    });
  }

  @override
  Widget build(BuildContext context) {
    //get data from provider
    final data = ref.watch(classDataProviderSummarization(widget.classId));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Summarization",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              toRightTransition(
                const LectBottomNavBar(initialIndex: 0),
              ),
            );
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
      ),
      body: data.when(
        data: (summarizationData) {
          // List<SummarizationModels> summarizationData = data;
          if (summarizationData.isEmpty) {
            return const Center(
              child: Text(
                "No Summarization Found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          //Start the liquid pull to refresh
          return LiquidPullToRefresh(
            onRefresh: () => _handleRefresh(ref),
            color: Colors.deepPurple,
            height: 100,
            animSpeedFactor: 2,
            backgroundColor: Colors.deepPurple[200],
            showChildOpacityTransition: false,
            child: Skeletonizer(
              enabled: _isRefreshing,
              effect: ShimmerEffect(),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 5.0),
                        child: Text(
                          "Summarization Result",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LecturerEditsummarization(
                                  summarizationData: summarizationData[0]
                                      .summaryText
                                      .split(
                                          '\n'), // Split the string into a list of strings
                                  summarizationClassId: widget.classId,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_note),
                          iconSize: 28,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Displaying a nice status indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: summarizationData[0].publishStatus ==
                                    "Published"
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            summarizationData[0].publishStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15),
                              child: _buildSummaryText(
                                  summarizationData[0].summaryText),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100.0,
                      vertical: 20,
                    ),
                    child: CustomButton(
                      onTap: () async {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title: 'Publish Class ?',
                          text:
                              'Are you sure you want to publish this summarization ? The student can access right after this.',
                          confirmBtnText: 'Publish',
                          cancelBtnText: 'Cancel',
                          onConfirmBtnTap: () async {
                            Navigator.pop(context);
                            // Call the publish function from the provider
                            final result =
                                await Summarizationapi.updatePublishStatus(
                                    summarizationData[0].classId, "Published");

                            if (result) {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Class published successfully',
                                confirmBtnText: 'OK',
                                onConfirmBtnTap: () {
                                  Navigator.pop(
                                      context); // Closes the dialog and stays on the same page
                                },
                              );
                            } else {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                text: 'Failed to publish class, try again!',
                                confirmBtnText: 'OK',
                                onConfirmBtnTap: () {
                                  Navigator.pop(
                                      context); // Closes the dialog and stays on the same page
                                },
                              );
                            }
                          },
                        );
                      }, //Buat function sini untuk publish
                      isLoading: _isRefreshing,
                      icon: Icons.upload_rounded,
                      text: summarizationData[0].publishStatus == "Published"
                          // Check the publish status and set the text accordingly
                          ? "Re-Publish"
                          : "Publish", // Pass a String for the text parameter
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (err, s) => Center(child: Text(err.toString())),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Column _buildSummaryText(String text) {
    final regex = RegExp(r'\*\*(.*?)\*\*'); // Matches text between ** **
    List<InlineSpan> spans = [];
    int lastIndex = 0;

    // Process all regex matches
    for (final match in regex.allMatches(text)) {
      // Add plain text before the match
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'FigtreeRegular',
            color: Colors.black,
          ),
        ));
      }

      // Add bolded text for the match
      spans.add(TextSpan(
        text: "\n${match.group(1)}", // The text inside ** **
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ));

      // Update the last processed index
      lastIndex = match.end;
    }

    // Add any remaining plain text after the last match
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'FigtreeRegular',
          color: Colors.black,
        ),
      ));
    }

    // Return the RichText widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: spans, // Your generated spans with regex
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              height: 1.6, // Adjust line height for readability
            ),
          ),
        ),
        const SizedBox(height: 20), // Add space below the last match
      ],
    );
  }
}
