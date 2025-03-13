import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_editsummarization.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/template/lecturer_bottom_navbar.dart';

class LecturerViewsummarization extends ConsumerWidget {
  final int classId;

  const LecturerViewsummarization({super.key, required this.classId});

  //Handle refresh and reload the data from data providero
  Future<void> _handleRefresh(WidgetRef ref) async {
    //Reload the daaata from provider
    // ignore: unused_result, await_only_futures
    await ref.refresh(classDataProviderSummarization(classId).future);
    //reloading take some time..
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //get data from provider
    final data = ref.watch(classDataProviderSummarization(classId));
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
              MaterialPageRoute(
                builder: (context) {
                  return const LectBottomNavBar(initialIndex: 0);
                },
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
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 13.0),
                      child: Text(
                        "Summarization Result",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                                        '\n'), // Split the string into a list of strings,
                                summarizationClassId: classId,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_note),
                        iconSize: 28,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
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
              ],
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
