class ClassroomModels {
  final int classroomId;
  final String classroomName;
  final String group_developer_id;

  ClassroomModels({
    required this.classroomId,
    required this.classroomName,
    required this.group_developer_id ,
  });

  // Convert a Map to a ClassroomModels object
  factory ClassroomModels.fromJson(Map<String, dynamic> json) {
    return ClassroomModels(
      classroomId: json['classroomId'] ?? 0,
      classroomName: json['classroomName'] ?? "Unknown Classroom",
      group_developer_id: json['group_developer_id'] ?? "Unknown Developer ID",
    );
  }

  @override
  String toString() {
    return classroomName;
  }
}
