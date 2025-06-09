class CreateClassroomMode {
  final String classroomName;

  CreateClassroomMode({
    required this.classroomName,
  });

  // Convert a CreateClassroomMode object to a Map
  Map<String, dynamic> toJson() {
    return {
      'classroomName': classroomName,
    };
  }
}
