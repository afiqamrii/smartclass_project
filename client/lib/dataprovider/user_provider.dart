import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/models/lecturer/user.dart';

class UserProvider extends Notifier<User> {
  @override
  User build() => User(
        userId: '',
        userName: '',
        userEmail: '',
        userPassword: '',
        token: '',
        userRole: 0,
      );

  // Set user data
  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  //Set user from model
  void setUserFromModel(User user) {
    state = user;
  }
}

final authProvider = NotifierProvider<UserProvider, User>(() {
  return UserProvider();
});
