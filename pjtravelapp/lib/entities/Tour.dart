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
