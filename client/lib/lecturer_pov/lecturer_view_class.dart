import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/lecturer_pov/lecturer_update_class.dart';
import '../models/class_models.dart';
import '../services/api.dart';

class LecturerViewClass extends StatelessWidget {
  final ClassModel classItem;

  const LecturerViewClass({Key? key, required this.classItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          '${classItem.courseCode} - ${classItem.courseName}',
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _topClassCard(context),
          const SizedBox(height: 16),
          _deleteButton(context),
        ],
      ),
    );
  }

  Padding _topClassCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 6,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3700B3), Color(0xFF6200EA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  // Left Section: Picture
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/pictures/compPicture.jpg',
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right Section: Text Details
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "${classItem.courseCode} - ${classItem.courseName}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time_outlined,
                                  color: Colors.white70, size: 20),
                              const SizedBox(width: 5.0),
                              Text(
                                "${classItem.startTime} - ${classItem.endTime}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  color: Colors.white70, size: 20),
                              const SizedBox(width: 5.0),
                              Text(
                                classItem.date,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  color: Colors.white70, size: 20),
                              const SizedBox(width: 5.0),
                              Text(
                                classItem.location,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Text(
                            "Lecturer: Dr Nor",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: () {
                // Action when the edit icon is tapped
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit button tapped!')),
                );
              },
              child: Container(
                child: IconButton(
                  icon: Image.asset(
                    'assets/icons/edit-button.png',
                    color: Colors.white,
                    width: 24.0, // Adjust the width as needed
                    height: 24.0, // Adjust the height as needed
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LectUpdateClass(classItem: classItem)));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
            Navigator.pop(context);
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
