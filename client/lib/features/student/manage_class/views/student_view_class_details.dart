import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:skeletonizer/skeletonizer.dart';

import 'package:smartclass_fyp_2024/features/student/models/todayClass_card_models.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';

import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class StudentViewClassDetails extends ConsumerStatefulWidget {
  const StudentViewClassDetails({super.key, required this.classItem});

  @override
  ConsumerState<StudentViewClassDetails> createState() =>
      _StudentViewClassDetailsState();

  final TodayclassCardModels classItem;
}

class _StudentViewClassDetailsState
    extends ConsumerState<StudentViewClassDetails> {
  // ignore: unused_field
  bool _isRefreshing = false;
  late ScrollController _scrollController;
  bool _isScrolled = false;

  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() {
      _isRefreshing = true;
    });

    await ref.read(userProvider.notifier).refreshUserData();
    // await ref.read(classDataProvider.future);
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isRefreshing = false;
    });
  }

  //Check if class is over or not
  bool isClassOver(String classStartTime, String classEndTime) {
    final now = DateTime.now();

    DateTime parseTime(String timeStr) {
      final format = DateFormat.jm(); // handles '2:13 PM'
      final time = format.parse(timeStr);
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    }

    final startTime = parseTime(classStartTime);
    final endTime = parseTime(classEndTime);

    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(
        () {
          if (_scrollController.offset > 50 && !_isScrolled) {
            setState(() {
              _isScrolled = true;
            });
          } else if (_scrollController.offset <= 50 && _isScrolled) {
            setState(() {
              _isScrolled = false;
            });
          }
        },
      );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final data = ref.watch(classByIdProvider(widget.classItem.classId));

    //Get summarization data
    final summarizationData =
        ref.watch(studentSummarizationProvider(widget.classItem.classId));

    return data.when(
      data: (classData) {
        if (classData.isEmpty) {
          return const Center(child: Text('Class not found'));
        }

        final classItem = classData.first;
        final screenHeight = MediaQuery.of(context).size.height;

        return Skeletonizer(
          enabled: _isRefreshing,
          child: Scaffold(
            backgroundColor: Colors.black87,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: _isScrolled ? Colors.white : Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: _isScrolled ? Colors.black : Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                classItem.courseName,
                style: TextStyle(
                  fontSize: 15,
                  color: _isScrolled ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              shape: _isScrolled
                  ? Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    )
                  : null,
            ),
            body: RefreshIndicator(
              onRefresh: () => _handleRefresh(ref),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Column(
                  children: [
                    // Top image with glassmorphism appbar and gradient
                    Stack(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.44,
                          width: double.infinity,
                          child: Skeletonizer(
                            enabled: _isRefreshing,
                            child: Image.network(
                              classItem.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/pictures/compPicture.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        // Top black gradient to enhance AppBar visibility
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 170,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black87, // Dark at the top
                                  Colors.transparent, // Fade out
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Bottom white gradient for blending
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 400,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black,
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Put all part to display class details
                        Positioned(
                          top: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 60),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                              "${classItem.courseCode} - ${classItem.courseName}",
                                              style: TextStyle(
                                                color: Colors.grey.shade200,
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "${classItem.startTime} - ${classItem.endTime}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                              fontFamily: 'FigtreeRegular',
                                            ),
                                          ),
                                          Text(
                                            classItem.date,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                              fontFamily: 'FigtreeRegular',
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Text(
                                              "Lecturer : ${userData.name} | Location : ${classItem.location}",
                                              style: TextStyle(
                                                color: Colors.grey.shade200,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Minimalist and structured class details section
                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Welcome to ${classItem.courseName} !",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Figtree',
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),

                          //Class status section
                          if (!isClassOver(
                              classItem.startTime, classItem.endTime))
                            Row(
                              children: [
                                Text(
                                  "Status : ",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Completed",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          if (isClassOver(
                              classItem.startTime, classItem.endTime))
                            Row(
                              children: [
                                Text(
                                  "Status : ",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Ongoing",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 15),
                          // Summarization Section
                          const Text(
                            "Class Summarization",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          summarizationData.when(
                            data: (summarizationData) {
                              if (summarizationData.isEmpty) {
                                return Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "No summary available yet. Please check after the class has ended.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }
                              return IntrinsicHeight(
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
                              );
                            },
                            error: (error, stackTrace) =>
                                Text(error.toString()),
                            loading: () => const CircularProgressIndicator(),
                          ),

                          const SizedBox(height: 25),

                          // Optionally add more sections here (e.g., notes, files, feedback)
                          // const Text("Lecture Notes"),
                          // ...
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error: $error',
          style: const TextStyle(color: Colors.red),
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

  // Card _classCardSection(
  //     ClassCreateModel classItem, BuildContext context, User userData) {
  //   final bool isPastClass = DateTime.now()
  //       .isAfter(DateFormat('dd MMMM yyyy').parse(classItem.date));

  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     clipBehavior: Clip.antiAlias,
  //     child: IntrinsicHeight(
  //       child: Stack(
  //         fit: StackFit.expand,
  //         children: [
  //           Skeletonizer(
  //             enabled: _isRefreshing,
  //             child: Image.network(
  //               classItem.imageUrl,
  //               fit: BoxFit.cover,
  //               errorBuilder: (_, __, ___) {
  //                 return Image.asset(
  //                   'assets/pictures/compPicture.jpg',
  //                   fit: BoxFit.cover,
  //                 );
  //               },
  //             ),
  //           ),
  //           Positioned(
  //             top: 10,
  //             left: 0,
  //             right: 0,
  //             bottom: 0,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   begin: Alignment.bottomCenter,
  //                   end: Alignment.topCenter,
  //                   colors: [
  //                     Colors.black.withOpacity(1),
  //                     Colors.transparent,
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(15.0),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     // Only show edit button if NOT today

  //                     GestureDetector(
  //                       onTap: () {
  //                         Navigator.push(
  //                           context,
  //                           toLeftTransition(
  //                             LectUpdateClass(
  //                               classItem: classItem,
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                       child: isPastClass
  //                           ? Image.asset(
  //                               'assets/icons/editicon.png',
  //                               height: 25,
  //                               width: 25,
  //                               color: Colors.transparent,
  //                             )
  //                           : Image.asset(
  //                               'assets/icons/editicon.png',
  //                               height: 25,
  //                               width: 25,
  //                             ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 60),
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                     left: 10.0,
  //                     right: 10,
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           SizedBox(
  //                             width: MediaQuery.of(context).size.width * 0.7,
  //                             child: Text(
  //                               "${classItem.courseCode} - ${classItem.courseName}",
  //                               style: const TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                               maxLines: 2,
  //                               overflow: TextOverflow.ellipsis,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 5),
  //                           Text(
  //                             "${classItem.startTime} - ${classItem.endTime}",
  //                             style: const TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 13,
  //                               fontFamily: 'FigtreeRegular',
  //                             ),
  //                           ),
  //                           Text(
  //                             classItem.date,
  //                             style: const TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 13,
  //                               fontFamily: 'FigtreeRegular',
  //                             ),
  //                           ),
  //                           const SizedBox(height: 10),
  //                           SizedBox(
  //                             width: MediaQuery.of(context).size.width * 0.7,
  //                             child: Text(
  //                               "Lecturer : ${userData.name} | Location : ${classItem.location}",
  //                               style: const TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 13,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

