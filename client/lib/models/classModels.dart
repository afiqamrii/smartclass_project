import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClasTestModel {
  final int id;
  final String courseCode;
  final String courseName;
  final String location;
  final String startTime;
  final String endTime;
  final String date;
  final String summarization;

  ClasTestModel(
      {required this.id,
      required this.courseCode,
      required this.courseName,
      required this.location,
      required this.startTime,
      required this.endTime,
      required this.date,
      required this.summarization});

  static List<ClasTestModel> getClass() {
    List<ClasTestModel> classes = [];

    classes.add(ClasTestModel(
      id: 1,
      courseCode: 'CSE201',
      courseName: 'Data Structures and Algorithms',
      location: 'Room 202',
      startTime: '8:00 AM',
      endTime: '9:30 AM',
      date: '21 June 2023',
      summarization: 'Available',
    ));

    classes.add(ClasTestModel(
      id: 2,
      courseCode: 'CSE202',
      courseName: 'Software Engineering Principles',
      location: 'Room 305',
      startTime: '10:00 AM',
      endTime: '11:30 AM',
      date: '21 June 2023',
      summarization: 'Not Available',
    ));

    classes.add(ClasTestModel(
      id: 3,
      courseCode: 'CSA203',
      courseName: 'Operating Systems',
      location: 'Room 402',
      startTime: '1:00 PM',
      endTime: '2:30 PM',
      date: '21 June 2023',
      summarization: 'Available',
    ));

    classes.add(ClasTestModel(
      id: 4,
      courseCode: 'CSA204',
      courseName: 'Database Systems',
      location: 'Room 104',
      startTime: '3:00 PM',
      endTime: '4:30 PM',
      date: '21 June 2023',
      summarization: 'Available',
    ));

    classes.add(ClasTestModel(
      id: 5,
      courseCode: 'CSE205',
      courseName: 'Artificial Intelligence',
      location: 'Room 501',
      startTime: '5:00 PM',
      endTime: '6:30 PM',
      date: '21 June 2023',
      summarization: 'Not Available',
    ));

    return classes;
  }
}
