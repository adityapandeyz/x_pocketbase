import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_pocketbase/apis/storage_api.dart';
import 'package:x_pocketbase/apis/tweet_api.dart';
import 'package:x_pocketbase/constants/constants.dart';
import 'package:x_pocketbase/core/utils.dart';
import 'package:x_pocketbase/features/auth/controller/auth_controller.dart';

import '../../../core/enums/tweet_type_enum.dart';
import '../../../models/tweet_model.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    return TweetController(
        ref: ref,
        tweetAPI: ref.watch(tweetAPIProvider),
        storageAPI: ref.watch(storageAPIProvider));
  },
);

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetApi;
  final Ref _ref;
  final StorageAPI _storageAPI;
  TweetController(
      {required Ref ref,
      required TweetAPI tweetAPI,
      required StorageAPI storageAPI})
      : _ref = ref,
        _tweetApi = tweetAPI,
        _storageAPI = storageAPI,
        super(false);

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter tweet text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
      );
    } else {
      _shareTextTweet(
        text: text,
        context: context,
      );
    }
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hastags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uplodeImage(images, user.id);

    Tweet tweet = Tweet(
      text: text,
      hastags: hastags,
      link: link,
      imagesLinks: imageLinks,
      uid: user.id,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: [],
      commentsIds: [],
      id: '',
      reshareCount: 0,
    );

    print(tweet);

    final res = await _tweetApi.shareTweet(tweet);

    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hastags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;

    Tweet tweet = Tweet(
      text: text,
      hastags: hastags,
      link: link,
      imagesLinks: [],
      uid: user.id,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: [],
      commentsIds: [],
      id: '',
      reshareCount: 0,
    );

    print(tweet);

    final res = await _tweetApi.shareTweet(tweet);

    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('http://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
