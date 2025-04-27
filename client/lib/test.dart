// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';
// import 'package:smartclass_fyp_2024/shared/data/models/class_models.dart';
// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

// class MyWidget extends ConsumerWidget {
//   const MyWidget({super.key});

//   Future<void> _handleRefresh(WidgetRef ref) async {
//     //Reload the data in class provider
//     // ignore: await_only_futures, unused_result
//     await ref.refresh(classDataProvider);
//     //reloading take some time..
//     return await Future.delayed(const Duration(seconds: 1));
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final data = ref.watch(classDataProvider);
//     return Scaffold(
//       appBar: AppBar(title: const Text('Notifications')),
//       body: data.when(
//         data: (data) {
//           // ignore: unused_local_variable
//           List<ClassCreateModel> classItem = data;
//           return LiquidPullToRefresh(
//             onRefresh: () => _handleRefresh(ref),
//             color: Colors.deepPurple,
//             height: 100,
//             backgroundColor: Colors.deepPurple[200],
//             animSpeedFactor: 4,
//             showChildOpacityTransition: false,
//             //Sini start part in the body tu
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 //Make sure the picture follow the Card shape
//                 clipBehavior: Clip.antiAlias,
//                 child: IntrinsicHeight(
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       //Image layer
//                       Image.asset(
//                         'assets/pictures/compPicture.jpg',
//                         fit: BoxFit.cover,
//                       ),
//                       //Blur black gradient layer
//                       // Partial Blur and Black Overlay Layer
//                       Positioned(
//                         top: 50,
//                         left: 0,
//                         right: 0,
//                         bottom: 0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.bottomCenter,
//                               end: Alignment.topCenter,
//                               colors: [
//                                 Colors.black.withOpacity(0.8),
//                                 Colors.transparent,
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),

//                       //Text layer
//                       Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     // Handle process here
//                                   },
//                                   child: Image.asset(
//                                     'assets/icons/editicon.png',
//                                     height: 25,
//                                     width: 25,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 60),
//                             //Start of details or class in the card.
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 10.0, right: 10),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 0.6,
//                                         child: const Text(
//                                           'CSE3023 - Object Oriented Programming (K1)',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       //Time and date and lect name of the class goes hereeeee
//                                       const Text(
//                                         "11.00 a.m - 12.00 p.m",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       const Text(
//                                         "21 June 2024",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 0.7,
//                                         child: const Text(
//                                           "Lecturer : Dr Nor | "
//                                           "Location : BK-04 rom room",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 13,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//         error: (err, s) => Text(err.toString()),
//         loading: () => const Center(
//           child: CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
// }


// // Column(
// //               children: [
// //                 Expanded(
// //                   child: ListView.builder(
// //                     itemCount: classes.length,
// //                     itemBuilder: (_, index) {
// //                       return Card(
// //                         color: Colors.blueAccent,
// //                         child: ListTile(
// //                           title: Text(classes[index].courseName),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),