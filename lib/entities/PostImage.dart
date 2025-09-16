class PostImage {
  final int id;
  final String imageUrl;

  PostImage({
    required this.id,
    required this.imageUrl,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) => PostImage(
    id: json['id'],
    imageUrl: json['imageUrl'],
  );
}
