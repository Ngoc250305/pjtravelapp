import 'Account.dart';

class PostComment {
  final int commentId;
  final String content;
  final String createdAt;
  final Account account;

  PostComment({
    required this.commentId,
    required this.content,
    required this.createdAt,
    required this.account,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) => PostComment(
    commentId: json['commentId'],
    content: json['content'],
    createdAt: json['createdAt'],
    account: Account.fromJson(json['account']),
  );
}
