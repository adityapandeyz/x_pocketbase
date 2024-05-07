import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pocketbase/pocketbase.dart';

import '../core/core.dart';
import '../models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(pb: ref.watch(pocketbaseClientProvider));
});

abstract class ITweetApi {
  FutureEither shareTweet(Tweet tweet);

  Future<ResultList<RecordModel>> getTweets();
}

class TweetAPI implements ITweetApi {
  final PocketBase _pb;

  TweetAPI({required PocketBase pb}) : _pb = pb;

  @override
  FutureEither shareTweet(Tweet tweet) async {
    try {
      final record = await _pb.collection('tweets').create(
            body: tweet.toMap(),
          );

      return right(record);
    } catch (e, st) {
      return left(
        Failure(e.toString(), st),
      );
    }
  }

  @override
  Future<ResultList<RecordModel>> getTweets() async {
    final records = await _pb.collection('tweets').getList();
    return records;
  }
}
