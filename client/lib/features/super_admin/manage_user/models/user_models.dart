// ignore_for_file: non_constant_identifier_names

class UserModels {
  final int userId;
  final String userName;
  final String name;
  final String userEmail;
  final int roleId;
  final String roleName;
  final String externalId;
  final String user_picture_url;
  final String status;

  UserModels({
    required this.userId,
    required this.userName,
    required this.name,
    required this.userEmail,
    required this.roleId,
    required this.roleName,
    required this.externalId,
    required this.user_picture_url,
    required this.status,
  });

  //Convert JSON to UserModels
  factory UserModels.fromJson(Map<String, dynamic> json) => UserModels(
        userId: json['userId'] ?? 0,
        userName: json['userName'] ?? 'Unknown',
        name: json['name'] ?? 'Unknown',
        userEmail: json['userEmail'] ?? 'Unknown',
        roleId: json['roleId'] ?? 0,
        roleName: json['roleName'] ?? 'Unknown',
        externalId: json['externalId'] ?? 'Unknown',
        user_picture_url: json['user_picture_url'] ?? '',
        status: json['status'] ?? 'Unknown',
      );
}
