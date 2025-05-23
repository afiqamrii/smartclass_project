import 'dart:convert';

class User {
  final int? userId;
  final String userName;
  final String name;
  final String userEmail;
  final String userPassword;
  final String? confirmPassword;
  final String token;
  final int roleId;
  final String externalId;

  User({
    this.userId,
    required this.userName,
    required this.name,
    required this.userEmail,
    required this.userPassword,
    this.confirmPassword,
    required this.token,
    required this.roleId,
    required this.externalId,
  });

  // Convert a User object to a Map
  Map<String, dynamic> toMap() {
    return {
      if (userId != null)
        'userId': userId, // Include userId only if it's not null
      'userName': userName,
      'name': name,
      'userEmail': userEmail,
      'userPassword': userPassword,
      if (confirmPassword != null)
        'confirmPassword':
            confirmPassword, // Include confirmPassword only if it's not null
      'roleId': roleId,
      'token': token,
      'externalId': externalId,
    };
  }

  // Convert a Map to a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userPassword: map['userPassword'] ?? '',
      roleId: map['roleId'] ?? 0,
      token: map['token'] ?? '',
      externalId: map['externalId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
