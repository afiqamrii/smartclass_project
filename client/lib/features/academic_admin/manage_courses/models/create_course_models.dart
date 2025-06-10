class CreateCourseModels {
  
  final String courseCode;
  final String courseName;


  CreateCourseModels({

    required this.courseCode,
    required this.courseName,

  });

  //Model to JSON
  Map<String, dynamic> toJson() => {
    'courseCode': courseCode,
    'courseName': courseName,
  };

  @override
  String toString() => "$courseCode - $courseName";
}
