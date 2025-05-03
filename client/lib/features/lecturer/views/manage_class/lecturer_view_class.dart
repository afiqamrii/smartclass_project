import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/recording_state_notifier.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_show_all_classes.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_update_class.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_summarization/lecturer_viewSummarization.dart';
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

  @override
  Widget build(BuildContext context) {
    final recordingState =
        ref.watch(recordingStateProvider)[widget.classItem.classId] ??
            RecordingState(
              isRecording: false,
              micIcon: const Icon(
                Icons.mic_off_rounded,
                color: Colors.white,
                size: 20,
              ),
              recordingText: const Text(
                "Not recorded yet",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              micColor: const Color.fromARGB(255, 255, 61, 61),
            );

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
                        vertical: 20.0, horizontal: 20),
                    child: Card(
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
                                        child: Image.asset(
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
                                        left: 10.0, right: 10),
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
                                                  0.7,
                                              child: Text(
                                                "${classItem.courseCode} - ${classItem.courseName}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Text(
                                                "Lecturer : Dr Nor | Location : ${classItem.location}",
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
                    ),
                  ),
                  const SizedBox(height: 5),
                  //Features section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: IntrinsicHeight(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 10, bottom: 15),
                          child: Column(
                            children: [
                              //Attendance
                              _attendanceSection(),
                              Divider(
                                thickness: 1,
                                color: Colors.black.withOpacity(0.15),
                              ),
                              //Recording section
                              _recordingSection(recordingState, classItem),
                              Divider(
                                thickness: 1,
                                color: Colors.black.withOpacity(0.15),
                              ),
                              //View Summarization section
                              _viewSummarizationSection(context, classItem),
                              Divider(
                                thickness: 1,
                                color: Colors.black.withOpacity(0.15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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

  AppBar _appBarSection(BuildContext context, ClassCreateModel classItem) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            toRightTransition(
              const LectViewAllClass(),
            ),
          );
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

  Row _viewSummarizationSection(
      BuildContext context, ClassCreateModel classItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "View Summarization",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LecturerViewsummarization(
                  classId: classItem.classId,
                ),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Column _recordingSection(
      RecordingState recordingState, ClassCreateModel classItem) {
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
              child: Switch(
                value: recordingState.isRecording,
                activeColor: Colors.green,
                onChanged: (bool value) async {
                  await ref
                      .read(recordingStateProvider.notifier)
                      .toggleRecording(classItem.classId);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row _attendanceSection() {
    return Row(
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
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
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
