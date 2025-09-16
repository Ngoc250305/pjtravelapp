import 'Location.dart';

class Attraction {
  final int attractionId;
  final String name;
  final String description;
  final String openingHours;
  final double ticketPrice;
  final String imageUrl;
  final Location location;

  Attraction({
    required this.attractionId,
    required this.name,
    required this.description,
    required this.openingHours,
    required this.ticketPrice,
    required this.imageUrl,
    required this.location,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) => Attraction(
    attractionId: json['attractionId'],
    name: json['name'],
    description: json['description'],
    openingHours: json['openingHours'],
    ticketPrice: (json['ticketPrice'] as num).toDouble(),
    imageUrl: json['imageUrl'],
    location: Location.fromJson(json['location']),
  );
}
