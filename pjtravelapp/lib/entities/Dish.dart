import 'Location.dart';

class Dish {
  final int dishId;
  final String name;
  final String description;
  final String imageUrl;
  final Location location;

  Dish({
    required this.dishId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
  });

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
    dishId: json['dishId'],
    name: json['name'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    location: Location.fromJson(json['location']),
  );
}
