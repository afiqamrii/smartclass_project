import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/manage_attendance/views/lecturer_view_attendance.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/recording_state_notifier.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_show_all_classes.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_update_class.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_summarization/lecturer_viewSummarization.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import '../../../../shared/data/models/class_models.dart';
import '../../../../shared/data/services/classApi.dart';

class LecturerViewClass extends ConsumerStatefulWidget {
  const LecturerViewClass({super.key, required this.classItem});

  @override
  ConsumerState<LecturerViewClass> createState() => _LecturerViewClassState();

  final ClassCreateModel classItem;
}

class _LecturerViewClassState extends ConsumerState<LecturerViewClass> {
  // ignore: unused_field
  bool _isRefreshing = false;
  Map<int, bool> _pendingToggle = {};
  bool hasAutoStopped = false;

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

  bool isPastClassEndDateTime(String classDate, String endTime) {
    try {
      debugPrint("Raw endTime: $endTime");

      // Normalize all whitespace and remove weird chars
      endTime = endTime
          .replaceAll(RegExp(r'\u202F|\u00A0|\s+'),
              ' ') // non-breaking and multiple spaces
          .replaceAll('\u200E', '') // left-to-right mark
          .trim();

      debugPrint("Cleaned endTime: $endTime");

      // Parse date
      final classDateObj = DateFormat('dd MMMM yyyy').parse(classDate);

      // Parse time
      final parsedTime = DateFormat('h:mm a').parse(endTime);

      // Combine date + time
      final classEndDateTime = DateTime(
        classDateObj.year,
        classDateObj.month,
        classDateObj.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      debugPrint("Parsed class end datetime: $classEndDateTime");
      debugPrint("Current time: ${DateTime.now()}");

      return DateTime.now().isAfter(classEndDateTime);
    } catch (e) {
      debugPrint('Error parsing classDate or endTime: $e');
      return false;
    }
  }

  bool isToggleAllowed(String date, String startTime, String endTime) {
    final now = DateTime.now();

    // Clean strings to remove invisible or extra characters
    date = date.trim();
    startTime = startTime
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('\u202f', ' ')
        .trim();
    endTime = endTime
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('\u202f', ' ')
        .trim();

    try {
      final classDate = DateFormat("dd MMMM yyyy").parse(date);
      final parsedStartTime = DateFormat("h:mm a").parse(startTime);
      final parsedEndTime = DateFormat("h:mm a").parse(endTime);

      final fullStart = DateTime(classDate.year, classDate.month, classDate.day,
          parsedStartTime.hour, parsedStartTime.minute);
      final fullEnd = DateTime(classDate.year, classDate.month, classDate.day,
              parsedEndTime.hour, parsedEndTime.minute)
          .add(const Duration(minutes: 10)); // Add 10 mins grace

      return now.isAfter(fullStart) && now.isBefore(fullEnd);
    } catch (e) {
      // print("Date/time parsing error: $e");
      return false;
    }
  }

  bool shouldShowAttendance(String classDate) {
    // final now = DateTime.now();

    debugPrint('Class date: $classDate');

    // Parse the class date: e.g., "08 June 2025"
    final classDateObj = DateFormat('dd MMMM yyyy').parse(classDate);

    // Return true only if class date is today or earlier
    return classDateObj.isBefore(DateTime.now()) ||
        classDateObj.day == DateTime.now().day &&
            classDateObj.month == DateTime.now().month &&
            classDateObj.year == DateTime.now().year;
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final classId = widget.classItem.classId;
      final classEnd = isPastClassEndDateTime(
          widget.classItem.date, widget.classItem.endTime);
      final current = ref.read(recordingStateProvider)[classId];

      if (current == null) {
        ref.read(recordingStateProvider.notifier).initialize(classId);
      } else if (classEnd && current.isRecording) {
        // Only stop if it was still recording
        ref.read(recordingStateProvider.notifier).toggleRecording(classId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //Recoridng state
    final recordingState =
        ref.watch(recordingStateProvider)[widget.classItem.classId];

    if (recordingState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // ignore: unused_local_variable
    final userData = ref.watch(userProvider);
    final data = ref.watch(classByIdProvider(widget.classItem.classId));

    return data.when(
      data: (classData) {
        // Ensure we have at least one class item
        if (classData.isEmpty) {
          return const Center(
            child: Text('Class not found'),
          );
        }
        final classItem = classData.first;

        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: _appBarSection(context, classItem),
          body: RefreshIndicator(
            onRefresh: () => _handleRefresh(ref),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10,
                    ),
                    child: _classCardSection(classItem, context, userData),
                  ),
                  const SizedBox(height: 1),
                  //Features section
                  _featuresSection(recordingState, classItem, context),
                  _deleteButton(context, classItem),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) {
        return Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  Padding _featuresSection(RecordingState recordingState,
      ClassCreateModel classItem, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 1.0,
      ),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20,
              top: 5,
              bottom: 15,
            ),
            child: Column(
              children: [
                //Attendance
                //If class is over show attendance

                shouldShowAttendance(classItem.date)
                    ? _attendanceSection()
                    : const SizedBox.shrink(),

                if (shouldShowAttendance(classItem.date))
                  Divider(
                    thickness: 1,
                    color: Colors.black.withOpacity(0.1),
                  ),
                //Recording section
                _recordingSection(recordingState, classItem),
                Divider(
                  thickness: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                //View Summarization section
                _viewSummarizationSection(context, classItem),
                Divider(
                  thickness: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card _classCardSection(
      ClassCreateModel classItem, BuildContext context, User userData) {
    final bool isPastClass = DateTime.now()
        .isAfter(DateFormat('dd MMMM yyyy').parse(classItem.date));

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Skeletonizer(
              enabled: _isRefreshing,
              child: Image.network(
                classItem.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Image.asset(
                    'assets/pictures/compPicture.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Only show edit button if NOT today

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            toLeftTransition(
                              LectUpdateClass(
                                classItem: classItem,
                              ),
                            ),
                          );
                        },
                        child: isPastClass
                            ? Image.asset(
                                'assets/icons/editicon.png',
                                height: 25,
                                width: 25,
                                color: Colors.transparent,
                              )
                            : Image.asset(
                                'assets/icons/editicon.png',
                                height: 25,
                                width: 25,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                "${classItem.courseCode} - ${classItem.courseName}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
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
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'FigtreeRegular',
                              ),
                            ),
                            Text(
                              classItem.date,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'FigtreeRegular',
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                "Lecturer : ${userData.name} | Location : ${classItem.location}",
                                style: const TextStyle(
                                  color: Colors.white,
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
          ],
        ),
      ),
    );
  }

  AppBar _appBarSection(BuildContext context, ClassCreateModel classItem) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
        ),
      ),
      title: Text(
        '${classItem.courseCode} - ${classItem.courseName}',
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey[300]!,
          width: 1.0,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _viewSummarizationSection(
      BuildContext context, ClassCreateModel classItem) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          toLeftTransition(
            LecturerViewsummarization(
              classId: classItem.classId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 0.0,
          top: 10,
          bottom: 10,
          // right: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "View Summarizations",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Column _recordingSection(
    RecordingState recordingState,
    ClassCreateModel classItem,
  ) {
    final toggleAllowed =
        isToggleAllowed(classItem.date, classItem.startTime, classItem.endTime);

    final isRecording = recordingState.isRecording;

    // // ✅ Automatically stop recording if class has ended
    // if (!toggleAllowed && isRecording && !hasAutoStopped) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     ref
    //         .read(recordingStateProvider.notifier)
    //         .toggleRecording(classItem.classId);
    //     hasAutoStopped = true;
    //   });
    // }

    // print("Toggling recording for class ${classItem.classId}");
    // print("Toggle triggered: ${!recordingState.isRecording}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lecture Recording",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        if (!toggleAllowed)
          const Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 5),
            child: Text(
              "Recording can only be started during class time.",
              style: TextStyle(fontSize: 12, color: Colors.redAccent),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: recordingState.micColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: recordingState.micIcon,
                ),
                const SizedBox(width: 5),
                recordingState.recordingText,
              ],
            ),
            Transform.scale(
              scale: 0.75,
              child: Opacity(
                opacity: toggleAllowed ? 1.0 : 0.5,
                child: IgnorePointer(
                  ignoring: !toggleAllowed,
                  child: Switch(
                    value: isRecording,
                    activeColor: Colors.green.shade400,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey[300],
                    activeTrackColor: Colors.green.shade200,
                    onChanged: (_) async {
                      await ref
                          .read(recordingStateProvider.notifier)
                          .toggleRecording(classItem.classId);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _attendanceSection() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          toLeftTransition(
            LecturerViewAttendance(
              classId: widget.classItem.classId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 0.0,
          top: 10,
          bottom: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Attendance",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteButton(BuildContext context, ClassCreateModel classItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        onPressed: () async {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.confirm,
            title: 'Delete Class',
            text:
                'Are you sure you want to delete this class? This action cannot be undone.',
            confirmBtnText: 'Delete',
            cancelBtnText: 'Cancel',
            onConfirmBtnTap: () async {
              await Api.deleteClass(ApiConstants.baseUrl, classItem.classId);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LectViewAllClass();
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Class deleted successfully')),
              );
            },
          );
        },
        child: const Text(
          'Delete Class',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
