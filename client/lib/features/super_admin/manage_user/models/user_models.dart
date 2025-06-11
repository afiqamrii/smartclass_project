class UserModels {
  final int userId;
  final String userName;
  final String name;
  final String userEmail;
  final int roleId;
  final String roleName;
  final String externalId;

  UserModels({
    required this.userId,
    required this.userName,
    required this.name,
    required this.userEmail,
    required this.roleId,
    required this.roleName,
    required this.externalId,
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
      );

}
