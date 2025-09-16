import 'Location.dart';
import 'Account.dart';
import 'PostImage.dart';
import 'PostComment.dart';

class Post {
  final int postId;
  final String title;
  final String content;
  final List<PostImage> images;
  final bool isPublished;
  final String createdAt;
  final Location location;
  final Account account;
  final List<PostComment> comments;

  Post({
    required this.postId,
    required this.title,
    required this.content,
    required this.images,
    required this.isPublished,
    required this.createdAt,
    required this.location,
    required this.account,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    postId: json['postId'],
    title: json['title'],
    content: json['content'],
    images: (json['images'] as List)
        .map((item) => PostImage.fromJson(item))
        .toList(),
    isPublished: json['isPublished'],
    createdAt: json['createdAt'],
    location: Location.fromJson(json['location']),
    account: Account.fromJson(json['account']),
    comments: (json['comments'] as List)
        .map((item) => PostComment.fromJson(item))
        .toList(),
  );
}
