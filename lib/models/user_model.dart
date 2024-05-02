// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String email;
  final String name;
  List<dynamic> followers;
  List<dynamic> following;
  final String profilePic;
  final String bannerPic;
  final String id;
  final String bio;
  final bool hasXpremium;
  final String token;
  UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.following,
    required this.profilePic,
    required this.bannerPic,
    required this.id,
    required this.bio,
    required this.hasXpremium,
    required this.token,
  });

  UserModel copyWith({
    String? email,
    String? name,
    List<dynamic>? followers,
    List<dynamic>? following,
    String? profilePic,
    String? bannerPic,
    String? id,
    String? bio,
    bool? hasXpremium,
    String? token,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      id: id ?? this.id,
      bio: bio ?? this.bio,
      hasXpremium: hasXpremium ?? this.hasXpremium,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'followers': followers,
      'following': following,
      'profilePic': profilePic,
      'bannerPic': bannerPic,
      'id': id,
      'bio': bio,
      'hasXpremium': hasXpremium,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      followers:
          List<dynamic>.from((map['followers'] ?? [] as List<dynamic>)) ?? [],
      following:
          List<dynamic>.from((map['following'] ?? [] as List<dynamic>)) ?? [],
      profilePic: map['profilePic'] as String,
      bannerPic: map['bannerPic'] as String,
      id: map['id'] as String,
      bio: map['bio'] as String,
      hasXpremium: map['hasXpremium'] as bool,
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, followers: $followers, following: $following, profilePic: $profilePic, bannerPic: $bannerPic, id: $id, bio: $bio, hasXpremium: $hasXpremium, token: $token)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        other.profilePic == profilePic &&
        other.bannerPic == bannerPic &&
        other.id == id &&
        other.bio == bio &&
        other.hasXpremium == hasXpremium &&
        other.token == token;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        profilePic.hashCode ^
        bannerPic.hashCode ^
        id.hashCode ^
        bio.hashCode ^
        hasXpremium.hashCode ^
        token.hashCode;
  }
}
