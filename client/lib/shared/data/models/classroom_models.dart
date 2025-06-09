class ClassroomModels {
  final int classroomId;
  final String classroomName;
  // ignore: non_constant_identifier_names
  final String group_developer_id;
  // ignore: non_constant_identifier_names
  final String esp32_id;
  final String status;

  ClassroomModels({
    required this.classroomId,
    required this.classroomName,
    // ignore: non_constant_identifier_names
    required this.group_developer_id,
    // ignore: non_constant_identifier_names
    required this.esp32_id, // Default value for esp32_id
    required this.status,
  });

  // Convert a Map to a ClassroomModels object
  factory ClassroomModels.fromJson(Map<String, dynamic> json) {
    return ClassroomModels(
      classroomId: json['classroomId'] ?? 0,
      classroomName: json['classroomName'] ?? "Unknown Classroom",
      group_developer_id: json['group_developer_id'] ?? "Unknown Developer ID",
      esp32_id: json['esp32_id'] ?? "", // Default value for esp32_id
      status: json['is_active'] ?? "Yes",
    );
  }

  @override
  String toString() {
    return classroomName;
  }
}
