import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/recording_state_notifier.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_show_all_classes.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/lecturer_update_class.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_summarization/lecturer_viewSummarization.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import '../../../../shared/data/models/class_models.dart';
import '../../../../shared/data/services/classApi.dart';

class LecturerViewClass extends ConsumerWidget {
  final ClassCreateModel classItem;

  const LecturerViewClass({super.key, required this.classItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingState =
        ref.watch(recordingStateProvider)[classItem.classId] ??
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

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          LiquidPullToRefresh(
            onRefresh: () => _handleRefresh(),
            color: Colors.deepPurple,
            height: 100,
            backgroundColor: Colors.deepPurple[200],
            animSpeedFactor: 4,
            showChildOpacityTransition: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.antiAlias,
                child: IntrinsicHeight(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/pictures/compPicture.jpg',
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 50,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
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
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
          ),
          const SizedBox(height: 5),
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
                      Row(
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
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.black.withOpacity(0.15),
                      ),
                      Column(
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
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.black.withOpacity(0.15),
                      ),
                      Row(
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
                                  builder: (context) =>
                                      LecturerViewsummarization(
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
                      ),
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
    );
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(const Duration(seconds: 1));
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
