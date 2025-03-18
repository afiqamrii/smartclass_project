import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/models/lecturer/user.dart';

class UserProvider extends Notifier<User> {
  @override
  User build() => User(
        userId: 0,
        userName: '',
        userEmail: '',
        userPassword: '',
        token: '',
        roleId: 0,
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

final userProvider = NotifierProvider<UserProvider, User>(() {
  return UserProvider();
});

final loadingProvider = StateProvider<bool>((ref) => false);

