import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import 'package:x_pocketbase/constants/constants.dart';
import 'package:x_pocketbase/core/core.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    pb: ref.watch(pocketbaseClientProvider),
  );
});

class StorageAPI {
  final PocketBase _pb;

  StorageAPI({required PocketBase pb}) : _pb = pb;

  Future<List<String>> uplodeImage(List<File> files, String id) async {
    List<String> imageLinks = [];

    for (final file in files) {
      final uploadedImage = await _pb.collection('tweets').create(files: [
        http.MultipartFile.fromString(
          'tweet',
          file.path,
          filename: '$file',
        )
      ]);
      imageLinks.add(
        PocketBaseConstants.imageUrl(
          collectionName: uploadedImage.collectionName,
          userId: id,
          image: '$file',
        ),
      );
    }
    return imageLinks;
  }
}
