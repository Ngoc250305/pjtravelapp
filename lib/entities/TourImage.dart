class TourImage {
  final int id;
  final String original;
  final String thumbnail;

  TourImage({
    required this.id,
    required this.original,
    required this.thumbnail,
  });

  factory TourImage.fromJson(Map<String, dynamic> json) {
    return TourImage(
      id: json['id'] ?? 0,
      original: json['original']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original': original,
      'thumbnail': thumbnail,
    };
  }
}
