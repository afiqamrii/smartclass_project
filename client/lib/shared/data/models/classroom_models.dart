class ClassroomModels {
  final int classroomId;
  final String classroomName;

  ClassroomModels({
    required this.classroomId,
    required this.classroomName,
  });

  // Convert a Map to a ClassroomModels object
  factory ClassroomModels.fromJson(Map<String, dynamic> json) {
    return ClassroomModels(
      classroomId: json['classroomId'] ?? 0,
      classroomName: json['classroomName'] ?? "Unknown Classroom",
    );
  }

  @override
  String toString() {
    return classroomName;
  }
}
