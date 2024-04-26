import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pocketbase/pocketbase.dart';

import '../core/core.dart';

final authAPIProvider = Provider((ref) {
  final pb = ref.watch(pocketbaseProvider);
  return AuthAPI(pb: pb);
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

  Future currentUserAuthToken();
}

class AuthAPI implements IAuthAPI {
  final PocketBase _pb;
  final storage = const FlutterSecureStorage();
  AuthAPI({required PocketBase pb}) : _pb = pb;

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
      final record = await _pb.collection('users').authWithPassword(
            email,
            password,
          );

      final token = _pb.authStore.token;

      await storage.write(key: 'userAuthToken', value: token);

      print(record);

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
  Future currentUserAuthToken() async {
    try {
      String? userAuthToken = await storage.read(key: 'userAuthToken');

      print(userAuthToken);
      return userAuthToken;
    } catch (e, stackTrace) {
      print(e);
    }
  }
}
