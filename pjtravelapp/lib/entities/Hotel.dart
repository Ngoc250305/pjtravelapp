import 'Location.dart';

class Hotel {
  final int hotelId;
  final String name;
  final String address;
  final double rating;
  final String description;
  final String imageUrl;
  final Location location;

  Hotel({
    required this.hotelId,
    required this.name,
    required this.address,
    required this.rating,
    required this.description,
    required this.imageUrl,
    required this.location,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
    hotelId: json['hotelId'],
    name: json['name'],
    address: json['address'],
    rating: (json['rating'] as num).toDouble(),
    description: json['description'],
    imageUrl: json['imageUrl'],
    location: Location.fromJson(json['location']),
  );
}
