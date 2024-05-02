import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:x_pocketbase/models/user_model.dart';
import '../core/core.dart';

final authAPIProvider = Provider((ref) {
  return AuthAPI(
    pb: ref.watch(pocketbaseProvider),
  );
});

final currentUserIdProvider = FutureProvider((ref) {
  final authAPI = ref.watch(authAPIProvider);
  return authAPI.currentUserId();
});

abstract class IAuthAPI {
  FutureEither signup({
    required String email,
    required String password,
  });

  FutureEither login({
    required String email,
    required String password,
  });

  Future currentUserToken();
}

class AuthAPI implements IAuthAPI {
  final PocketBase _pb;
  final storage = const FlutterSecureStorage();
  AuthAPI({
    required PocketBase pb,
  }) : _pb = pb;

  @override
  FutureEither signup({
    required String email,
    required String password,
  }) async {
    try {
      final body = <String, dynamic>{
        //"username": "",
        "email": email,
        "password": password,
        "passwordConfirm": password,
        // "name": ""
      };

      final record = await _pb.collection('users').create(body: body);

      return right(record);
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  FutureEither login({
    required String email,
    required String password,
  }) async {
    try {
      final RecordAuth record = await _pb.collection('users').authWithPassword(
            email,
            password,
          );

      final UserModel userModel = UserModel(
        email: email,
        id: record.record!.id,
        token: record.token,
        name: record.record!.data['name'] ?? '',
        followers: [],
        following: [],
        profilePic: record.record!.data['profilePic'] ?? '',
        bannerPic: record.record!.data['bannerPic'] ?? '',
        bio: record.record!.data['bio'] ?? '',
        hasXpremium: record.record!.data['hasXpremium'] ?? false,
      );

      await storage.write(key: 'user', value: userModel.toJson());
      String? storageData = await storage.read(key: 'user');

      print(storageData);

      return right(record);
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  Future currentUserToken() async {
    try {
      String? storageData = await storage.read(key: 'user');
      if (storageData == null) {
        return null;
      }
      UserModel userModel = UserModel.fromJson(storageData);
      return userModel.token;
    } catch (e) {
      print(e);
    }
  }

  Future currentUserId() async {
    String? storageData = await storage.read(key: 'user');
    print(storageData);
    UserModel userModel = UserModel.fromJson(storageData!);
    return userModel.id;
  }
}
