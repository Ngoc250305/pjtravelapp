// // import 'UserProfile.dart';
// // import 'Post.dart';
// // import 'PostComment.dart';
// //
// // class Account {
// //   final int accountId;
// //   final String username;
// //   final String password;
// //   final String? email;
// //   final String role;
// //   final bool isActive;
// //   final String createdAt;
// //   final UserProfile? profile;
// //   final List<Post>? posts;
// //   final List<PostComment>? comments;
// //
// //   Account({
// //     required this.accountId,
// //     required this.username,
// //     required this.password,
// //     this.email,
// //     required this.role,
// //     required this.isActive,
// //     required this.createdAt,
// //     this.profile,
// //     this.posts,
// //     this.comments,
// //   });
// //
// //   // factory Account.fromJson(Map<String, dynamic> json) => Account(
// //   //   accountId: json['accountId'],
// //   //   username: json['username'],
// //   //   password: json['password'],
// //   //   // email: json['email'],
// //   //   email: json['email'] ?? '',
// //   //   role: json['role'],
// //   //   isActive: json['isActive'],
// //   //   createdAt: json['createdAt'],
// //   //   profile: json['profile'] != null
// //   //       ? UserProfile.fromJson(json['profile'])
// //   //       : null,
// //   //   posts: json['posts'] != null
// //   //       ? (json['posts'] as List).map((e) => Post.fromJson(e)).toList()
// //   //       : null,
// //   //   comments: json['comments'] != null
// //   //       ? (json['comments'] as List)
// //   //       .map((e) => PostComment.fromJson(e))
// //   //       .toList()
// //   //       : null,
// //   // );
// //   factory Account.fromJson(Map<String, dynamic> json) => Account(
// //     accountId: json['accountId'] ?? 0,
// //     username: json['username'] ?? '',
// //     password: json['password'] ?? '',
// //     email: json['email'] ?? '',
// //     role: json['role'] ?? '',
// //     isActive: json['isActive'] ?? false,
// //     createdAt: json['createdAt'] ?? '',
// //     profile: json['profile'] != null
// //         ? UserProfile.fromJson(json['profile'])
// //         : null,
// //     posts: json['posts'] != null
// //         ? (json['posts'] as List).map((e) => Post.fromJson(e)).toList()
// //         : null,
// //     comments: json['comments'] != null
// //         ? (json['comments'] as List).map((e) => PostComment.fromJson(e)).toList()
// //         : null,
// //   );
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'accountId': accountId,
// //       'username': username,
// //       'password': password,
// //       'email': email,
// //       'role': role,
// //       'isActive':isActive,
// //       'createdAt': createdAt,
// //       'profile': profile
// //     };
// //   }
// // }
// import 'UserProfile.dart';
// import 'Post.dart';
// import 'PostComment.dart';
//
// class Account {
//   final int accountId;
//   final String username;
//   final String password;
//   final String? email;
//   final String role;
//   final bool isActive;
//   final String createdAt;
//   final UserProfile? profile;
//   final List<Post>? posts;
//   final List<PostComment>? comments;
//
//   Account({
//     required this.accountId,
//     required this.username,
//     required this.password,
//     this.email,
//     required this.role,
//     required this.isActive,
//     required this.createdAt,
//     this.profile,
//     this.posts,
//     this.comments,
//   });
//
//   factory Account.fromJson(Map<String, dynamic> json) => Account(
//     accountId: json['accountId'],
//     username: json['username'],
//     password: json['password'],
//     email: json['email'],
//     role: json['role'],
//     isActive: json['isActive'],
//     createdAt: json['createdAt'],
//     profile: json['profile'] != null
//         ? UserProfile.fromJson(json['profile'])
//         : null,
//     posts: json['posts'] != null
//         ? (json['posts'] as List).map((e) => Post.fromJson(e)).toList()
//         : null,
//     comments: json['comments'] != null
//         ? (json['comments'] as List)
//         .map((e) => PostComment.fromJson(e))
//         .toList()
//         : null,
//   );
//   Map<String, dynamic> toJson() {
//     return {
//       'accountId': accountId,
//       'username': username,
//       'password': password,
//       'email': email,
//       'role': role,
//       'isActive':isActive,
//       'createdAt': createdAt,
//       'profile': profile
//     };
//   }
// }
import 'UserProfile.dart';
import 'Post.dart';
import 'PostComment.dart';

class Account {
  final int accountId;
  final String username;
  final String password;
  final String? email;
  final String role;
  final bool isActive;
  final String? createdAt;
  final UserProfile? profile;
  final List<Post>? posts;
  final List<PostComment>? comments;

  Account({
    required this.accountId,
    required this.username,
    required this.password,
    this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.profile,
    this.posts,
    this.comments,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    accountId: json['accountId'],
    username: json['username'],
    password: json['password'],
    email: json['email'],
    role: json['role'],
    isActive: json['isActive'],
    createdAt: json['createdAt'],
    profile: json['profile'] != null
        ? UserProfile.fromJson(json['profile'])
        : null,
    posts: json['posts'] != null
        ? (json['posts'] as List).map((e) => Post.fromJson(e)).toList()
        : null,
    comments: json['comments'] != null
        ? (json['comments'] as List)
        .map((e) => PostComment.fromJson(e))
        .toList()
        : null,
  );
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'username': username,
      'password': password,
      'email': email,
      'role': role,
      'isActive':isActive,
      'createdAt': createdAt,
      'profile': profile
    };
  }
}
