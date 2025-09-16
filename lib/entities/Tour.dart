import 'Location.dart';
import 'Account.dart';
import 'TourSchedule.dart';

class Tour {
  final int tourID;
  final String title;
  final String description;
  final Location location;
  final Account account;
  final List<TourSchedule> tourSchedules;
  final String startDate;
  final String endDate;
  final double price;
  final String createdAt;
  final bool isApproved;
  final String imageUrl;

  Tour({
    required this.tourID,
    required this.title,
    required this.description,
    required this.location,
    required this.account,
    required this.tourSchedules,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.createdAt,
    required this.isApproved,
    required this.imageUrl,
  });

  factory Tour.fromJson(Map<String, dynamic> json) => Tour(
    tourID: json['tourID'],
    title: json['title'],
    description: json['description'],
    location: Location.fromJson(json['location']),
    account: Account.fromJson(json['account']),
    tourSchedules: (json['tourSchedules'] as List)
        .map((e) => TourSchedule.fromJson(e))
        .toList(),
    startDate: json['startDate'],
    endDate: json['endDate'],
    price: (json['price'] as num).toDouble(),
    createdAt: json['createdAt'],
    isApproved: json['isApproved'],
    imageUrl: json['imageUrl'],
  );
}
// class Tour {
//   final int id;
//   final String title;
//   final String urls;
//   final double rating;
//   final int reviews;
//   final double price;
//   final List<dynamic> itineraries;
//   final List<dynamic> tourInfo;
//
//   Tour({
//     required this.id,
//     required this.title,
//     required this.urls,
//     required this.rating,
//     required this.reviews,
//     required this.price,
//     required this.itineraries,
//     required this.tourInfo,
//   });
//
//   factory Tour.fromJson(Map<String, dynamic> json) {
//     return Tour(
//       id: json['id'],
//       title: json['title'] ?? '',
//       urls: json['urls'] ?? '',
//       rating: (json['rating'] ?? 0).toDouble(),
//       reviews: json['reviews'] ?? 0,
//       price: (json['price'] ?? 0).toDouble(),
//       itineraries: json['itineraries'] ?? [],
//       tourInfo: json['tourInfo'] ?? [],
//     );
//   }
// }
