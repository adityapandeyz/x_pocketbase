// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:x_pocketbase/core/enums/tweet_type_enum.dart';

class Tweet {
  final String text;
  final List<String> hastags;
  final String link;
  final List<String> imagesLinks;
  final String uid;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentsIds;
  final String id;
  final int reshareCount;
  Tweet({
    required this.text,
    required this.hastags,
    required this.link,
    required this.imagesLinks,
    required this.uid,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentsIds,
    required this.id,
    required this.reshareCount,
  });

  Tweet copyWith({
    String? text,
    List<String>? hastags,
    String? link,
    List<String>? imagesLinks,
    String? uid,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? commentsIds,
    String? id,
    int? reshareCount,
  }) {
    return Tweet(
      text: text ?? this.text,
      hastags: hastags ?? this.hastags,
      link: link ?? this.link,
      imagesLinks: imagesLinks ?? this.imagesLinks,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      commentsIds: commentsIds ?? this.commentsIds,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hastags': hastags,
      'link': link,
      'imagesLinks': imagesLinks,
      'uid': uid,
      'tweetType': tweetType.type,
      'tweetedAt': tweetedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentsIds': commentsIds,
      'reshareCount': reshareCount,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] as String,
      hastags: List<String>.from((map['hastags'] as List<String>)),
      link: map['link'] as String,
      imagesLinks: List<String>.from((map['imagesLinks'] as List<String>)),
      uid: map['uid'] as String,
      tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt'] as int),
      likes: List<String>.from((map['likes'] as List<String>)),
      commentsIds: List<String>.from((map['commentsIds'] as List<String>)),
      id: map['id'] as String,
      reshareCount: map['reshareCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tweet.fromJson(String source) =>
      Tweet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Tweet(text: $text, hastags: $hastags, link: $link, imagesLinks: $imagesLinks, uid: $uid, tweetType: $tweetType, tweetedAt: $tweetedAt, likes: $likes, commentsIds: $commentsIds, id: $id, reshareCount: $reshareCount)';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        listEquals(other.hastags, hastags) &&
        other.link == link &&
        listEquals(other.imagesLinks, imagesLinks) &&
        other.uid == uid &&
        other.tweetType == tweetType &&
        other.tweetedAt == tweetedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentsIds, commentsIds) &&
        other.id == id &&
        other.reshareCount == reshareCount;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hastags.hashCode ^
        link.hashCode ^
        imagesLinks.hashCode ^
        uid.hashCode ^
        tweetType.hashCode ^
        tweetedAt.hashCode ^
        likes.hashCode ^
        commentsIds.hashCode ^
        id.hashCode ^
        reshareCount.hashCode;
  }
}
