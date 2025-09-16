import 'Location.dart';

class Restaurant {
  final int restaurantId;
  final String name;
  final String address;
  final String description;
  final String imageUrl;
  final Location location;

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.location,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    restaurantId: json['restaurantId'],
    name: json['name'],
    address: json['address'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    location: Location.fromJson(json['location']),
  );
}
