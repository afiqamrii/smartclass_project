import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_show_all_classes.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_update_class.dart';
import '../models/lecturer/class_models.dart';
import '../services/lecturer/classApi.dart';

class LecturerViewClass extends StatefulWidget {
  final ClassModel classItem;

  const LecturerViewClass({super.key, required this.classItem});

  @override
  State<LecturerViewClass> createState() => _LecturerViewClassState();
}

class _LecturerViewClassState extends State<LecturerViewClass> {
  //Toggle light for lecture recording
  bool light = false;
  Icon initialMicIcon = const Icon(
    Icons.mic_off_rounded,
    color: Colors.white,
    size: 20,
  );
  // Set initial text for Recording
  Text initialRecordingText = const Text(
    "Recording",
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );
  //Set initial color for mic container
  Color initialColor = const Color.fromARGB(255, 255, 61, 61);

  //Refresh function
  Future<void> _handleRefresh() async {
    //reloading take some time..
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LectViewAllClass(),
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
          '${widget.classItem.courseCode} - ${widget.classItem.courseName}',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        // Give a border at the bottom
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
            //Sini start part in the body tu
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                //Make sure the picture follow the Card shape
                clipBehavior: Clip.antiAlias,
                child: IntrinsicHeight(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      //Image layer
                      Image.asset(
                        'assets/pictures/compPicture.jpg',
                        fit: BoxFit.cover,
                      ),
                      //Blur black gradient layer
                      // Partial Blur and Black Overlay Layer
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

                      //Text layer
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
                                      MaterialPageRoute(
                                        builder: (context) => LectUpdateClass(
                                          classItem: widget.classItem,
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
                            //Start of details or class in the card.
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
                                          "${widget.classItem.courseCode} - ${widget.classItem.courseName}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      //Time and date and lect name of the class goes hereeeee
                                      Text(
                                        "${widget.classItem.startTime} - ${widget.classItem.endTime}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: 'FigtreeRegular',
                                        ),
                                      ),
                                      Text(
                                        widget.classItem.date,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: 'FigtreeRegular',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          "Lecturer : Dr Nor | "
                                          "Location : ${widget.classItem.location}",
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
          //List of button section (Attendance , Lecture Recording Activation and See the Summarization)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
            ),
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
                      //Attendance Button Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Attendance button
                          const Text(
                            "Attendance",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.black.withOpacity(0.15),
                      ),
                      //Lecture Recording Activation button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Lecture Recording",
                            style: TextStyle(
                              fontSize: 18,
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
                                      color: initialColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: initialMicIcon,
                                  ),
                                  const SizedBox(width: 5),
                                  //Set initial recording text
                                  initialRecordingText,
                                ],
                              ),

                              //Toggle Switch for recording
                              Switch(
                                value: light,
                                activeColor: Colors.green,
                                onChanged: (bool value) async {
                                  //Switch toogle for lecture recording activation here
                                  setState(() {
                                    light = value;
                                    if (light == true) {
                                      initialMicIcon = const Icon(
                                        Icons.mic,
                                        size: 20,
                                        color: Colors.white,
                                      );
                                      //Set initial color of caontainer to green
                                      initialColor = Colors.green;
                                      //Set text to "Recording Started"
                                      initialRecordingText = const Text(
                                        "Recording Started !",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                        ),
                                      );
                                    }
                                    if (light == false) {
                                      initialMicIcon = const Icon(
                                        Icons.mic_off,
                                        size: 20,
                                        color: Colors.white,
                                      );
                                      //Set initial color of container to red back
                                      initialColor = Colors.red;
                                      //Set text to "Recording"

                                      initialRecordingText = const Text(
                                        "Recording",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      );
                                    }
                                  });

                                  // Handle when toggle is tapped here
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.black.withOpacity(0.15),
                      ),
                      //Summarization button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "View Summarization",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
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
          _deleteButton(context),
        ],
      ),
    );
  }

  // Padding _topClassCard(BuildContext context) {
  Widget _deleteButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // Background color
        ),
        onPressed: () async {
          bool confirm = await _showConfirmationDialog(context);
          if (confirm) {
            await Api.deleteClass(Api.baseUrl, widget.classItem.classId);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Class deleted successfully')),
            );
          }
        },
        child: const Text(
          'Delete Class',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content:
                  const Text('Are you sure you want to delete this class?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
