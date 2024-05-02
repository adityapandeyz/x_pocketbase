import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:x_pocketbase/core/core.dart';

import '../models/user_model.dart';

final userAPIProvider = Provider((ref) {
  final pb = ref.watch(pocketbaseProvider);
  return UserAPI(pb: pb);
});

abstract class IUserAPI {
  Future<RecordModel> getUserData(String uid);

  Future<UserModel> currentUserData();
}

class UserAPI implements IUserAPI {
  final PocketBase _pb;
  final storage = const FlutterSecureStorage();
  UserAPI({required PocketBase pb}) : _pb = pb;

  @override
  Future<RecordModel> getUserData(String id) async {
    print(id);

    final record = await _pb.collection('users').getOne(
          id,
          expand: 'relField1,relField2.subRelField',
        );
    return record;
  }

  @override
  Future<UserModel> currentUserData() async {
    String? storageData = await storage.read(key: 'user');
    UserModel userModel = UserModel.fromJson(storageData!);
    return userModel;
  }
}
