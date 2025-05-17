class UtilityIssueModel {
  final int issueId;
  final String issueTitle;
  final String issueDescription;
  final String userId;
  final String issueStatus;
  final String imageUrl;
  final int classroomId;
  final String userName;
  final String classroomName;

  UtilityIssueModel({
    required this.issueId,
    required this.issueTitle,
    required this.issueDescription,
    required this.userId,
    required this.issueStatus,
    required this.imageUrl,
    required this.classroomId,
    required this.userName,
    required this.classroomName,
  });

  // Convert JSON object to UtilityIssueModel
  factory UtilityIssueModel.fromJson(Map<String, dynamic> json) {
    return UtilityIssueModel(
      issueId: json['issueId'],
      issueTitle: json['issueTitle'],
      issueDescription: json['issueDescription'],
      userId: json['userId'],
      issueStatus: json['issueStatus'],
      imageUrl: json['imageUrl'],
      classroomId: json['classroomId'],
      userName: json['userName'],
      classroomName: json['classroomName'],
    );
  }

  // Convert UtilityIssueModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'issueId': issueId,
      'issueTitle': issueTitle,
      'issueDescription': issueDescription,
      'userId': userId,
      'issueStatus': issueStatus,
      'imageUrl': imageUrl,
      'classroomId': classroomId,
      'userName': userName,
      'classroomName': classroomName,
    };
  }
}
