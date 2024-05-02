import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:x_pocketbase/apis/auth_api.dart';
import 'package:x_pocketbase/core/utils.dart';
import 'package:x_pocketbase/features/auth/view/login_view.dart';
import 'package:x_pocketbase/features/home/view/home_view.dart';

import '../../../apis/user_api.dart';
import '../../../models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) async {
  final currentUserId = ref.watch(currentUserIdProvider).value!;
  print('currentUserDetailsProvider: $currentUserId');
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  print('userDetailsProvider: ${userDetails.value}');
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String id) {
  final authController = ref.watch(authControllerProvider.notifier);
  print('userDetailsProvider: ${authController.getUserData(id)}');
  return authController.getUserData(id);
});

final currentUserIdProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  print('currentUserIdProvider : ${authController.currentUserId()}');
  return authController.currentUserId();
});

final currentUserTokenProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);

  return authController.currentUserToken();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  //state = isLoading

  Future currentUserId() => _authAPI.currentUserId();
  Future currentUserToken() => _authAPI.currentUserToken();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;

    final res = await _authAPI.signup(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Account created! Please login');
        Navigator.push(context, LoginView.route());
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;

    final res = await _authAPI.login(
      email: email,
      password: password,
    );

    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.push(context, HomeView.route());
      },
    );
  }

  Future<UserModel> getUserData(String id) async {
    final userData = await _userAPI.getUserData(id);

    final UserModel updatedUser = UserModel(
      id: userData.id,
      email: userData.data['email'],
      name: userData.data['name'],
      followers: [],
      following: [],
      profilePic: userData.data['profilePic'],
      bannerPic: userData.data['bannerPic'],
      bio: userData.data['bio'],
      hasXpremium: userData.data['hasXpremium'],
      token: '',
    );
    print('getUserData: $updatedUser');
    return updatedUser;
  }
}
