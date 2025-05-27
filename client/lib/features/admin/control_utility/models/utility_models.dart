// models/utility_models.dart
class UtilityModels {
  final int utilityId;
  final String utilityName;
  final String utilityStatus;
  final String deviceId;
  final int classroomId;
  final String topic;
  final String utilityType;

  UtilityModels({
    required this.utilityId,
    required this.utilityName,
    required this.utilityStatus,
    required this.deviceId,
    required this.classroomId,
    required this.topic,
    required this.utilityType,
  });

  // Convert a Map to a UtilityModels object
  factory UtilityModels.fromJson(Map<String, dynamic> json) {
    return UtilityModels(
      utilityId: json['utilityId'] ?? 0,
      utilityName: json['utilityName'] ?? "Unknown Utility",
      utilityStatus: json['utilityStatus'] ?? "Unknown Status",
      deviceId: json['device_id'] ??
          "Unknown Device ID", // Maps 'device_id' from JSON
      classroomId: json['classroomId'] ?? 0,
      topic: json['topic'] ?? "No Topic",
      utilityType: json['utilityType'] ?? "Unknown Type",
    );
  }

  // Correctly implemented copyWith method
  UtilityModels copyWith({
    int? utilityId,
    String? utilityName,
    String?
        utilityStatus, // This will be the 'newStatus' passed from the provider
    String? deviceId,
    int? classroomId,
    String? topic,
  }) {
    return UtilityModels(
      utilityId: utilityId ?? this.utilityId,
      utilityName: utilityName ?? this.utilityName,
      utilityStatus: utilityStatus ??
          this.utilityStatus, // Use new status if provided, else old
      deviceId: deviceId ?? this.deviceId,
      classroomId: classroomId ?? this.classroomId,
      topic: topic ?? this.topic,
      utilityType: utilityType,
    );
  }
}
