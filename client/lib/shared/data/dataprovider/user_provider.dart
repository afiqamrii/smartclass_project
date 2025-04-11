import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/shared/data/services/auth_services.dart';

class UserProvider extends StateNotifier<User> {
  UserProvider()
      : super(User(
          userId: 0,
          userName: '',
          userEmail: '',
          userPassword: '',
          token: '',
          roleId: 0,
          externalId: '',
        ));

  // Set user data from JSON
  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  // Set user directly from model
  void setUserFromModel(User user) {
    state = user;
  }

  // Refresh user data from API
  Future<void> refreshUserData() async {
    final newUser = await AuthService().getUserData();
    if (newUser != null) {
      state = newUser;
    }
  }
}

// Register as a StateNotifierProvider
final userProvider = StateNotifierProvider<UserProvider, User>((ref) {
  return UserProvider();
});

// For UI loading state
final loadingProvider = StateProvider<bool>((ref) => false);
