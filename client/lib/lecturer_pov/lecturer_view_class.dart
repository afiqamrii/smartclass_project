import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_update_class.dart';
import '../models/class_models.dart';
import '../services/api.dart';

class LecturerViewClass extends StatelessWidget {
  final ClassModel classItem;

  const LecturerViewClass({super.key, required this.classItem});

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
                                          "${classItem.courseCode} - ${classItem.courseName}",
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
                                        "${classItem.startTime} - ${classItem.endTime}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        classItem.date,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
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
                                          "Location : ${classItem.location}",
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
          const SizedBox(height: 100),
          _deleteButton(context),
        ],
      ),
    );
  }

  // Padding _topClassCard(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
  //     child: Card(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //       //Make sure the picture follow the Card shape
  //       clipBehavior: Clip.antiAlias,
  //       child: IntrinsicHeight(
  //         child: Stack(
  //           fit: StackFit.expand,
  //           children: [
  //             //Image layer
  //             Image.asset(
  //               'assets/pictures/compPicture.jpg',
  //               fit: BoxFit.cover,
  //             ),
  //             //Blur black gradient layer
  //             // Partial Blur and Black Overlay Layer
  //             Positioned(
  //               top: 50,
  //               left: 0,
  //               right: 0,
  //               bottom: 0,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     begin: Alignment.bottomCenter,
  //                     end: Alignment.topCenter,
  //                     colors: [
  //                       Colors.black.withOpacity(0.85),
  //                       Colors.transparent,
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),

  //             //Text layer
  //             Padding(
  //               padding: const EdgeInsets.all(15.0),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           // Handle process here
  //                         },
  //                         child: Image.asset(
  //                           'assets/icons/editicon.png',
  //                           height: 25,
  //                           width: 25,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 50),
  //                   //Start of details or class in the card.
  //                   Padding(
  //                     padding: const EdgeInsets.only(
  //                         left: 7.0, right: 10, bottom: 5),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             SizedBox(
  //                               width: MediaQuery.of(context).size.width * 0.6,
  //                               child: Text(
  //                                 "${classItem.courseCode} - ${classItem.courseName}",
  //                                 style: const TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 18,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 5,
  //                             ),
  //                             //Time and date and lect name of the class goes hereeeee
  //                             Text(
  //                               "${classItem.startTime} - ${classItem.endTime}",
  //                               style: const TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 13,
  //                               ),
  //                             ),
  //                             Text(
  //                               classItem.date,
  //                               style: const TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 13,
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 5,
  //                             ),
  //                             SizedBox(
  //                               width: MediaQuery.of(context).size.width * 0.7,
  //                               child: const Text(
  //                                 "Lecturer : Dr Nor | "
  //                                 "Location : Halu ",
  //                                 style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 13,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
            await Api.deleteClass(Api.baseUrl, classItem.id);
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
