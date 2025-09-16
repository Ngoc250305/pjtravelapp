import 'Itinerary.dart';
import 'TourImage.dart';
import 'Booking.dart';
import 'Location.dart';

class TourDetail {
  final int id;
  final String title;
  final String description;
  final double rating;
  final String reviews;
  final String urls;
  final double price;
  final double discount;
  final List<String> tourInfo;
  final List<String> highlights;
  final List<Itinerary> itineraries;
  final List<String> included;
  final List<String> exclusion;
  final List<TourImage> images;
  final DateTime? startDate;
  final DateTime? endDate;
  final Location? location;
  final String taxFee;
  final bool isApproved;
  final List<Booking> bookings;

  TourDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.urls,
    required this.price,
    required this.discount,
    required this.tourInfo,
    required this.highlights,
    required this.itineraries,
    required this.included,
    required this.exclusion,
    required this.images,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.taxFee,
    required this.isApproved,
    required this.bookings,
  });

  factory TourDetail.fromJson(Map<String, dynamic> json) {
    return TourDetail(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews']?.toString() ?? '',
      urls: json['urls']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      tourInfo: (json['tourInfo'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      highlights: (json['highlights'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      itineraries: (json['itineraries'] as List<dynamic>?)
          ?.map((e) => Itinerary.fromJson(e))
          .toList() ??
          [],
      included: (json['included'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      exclusion: (json['exclusion'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => TourImage.fromJson(e))
          .toList() ??
          [],
      startDate:
      json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate:
      json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      location:
      json['location'] != null ? Location.fromJson(json['location']) : null,
      taxFee: json['taxFee']?.toString() ?? '',
      isApproved: json['isApproved'] ?? false,
      bookings: (json['bookings'] as List<dynamic>?)
          ?.map((e) => Booking.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rating': rating,
      'reviews': reviews,
      'urls': urls,
      'price': price,
      'discount': discount,
      'tourInfo': tourInfo,
      'highlights': highlights,
      'itineraries': itineraries.map((e) => e.toJson()).toList(),
      'included': included,
      'exclusion': exclusion,
      'images': images.map((e) => e.toJson()).toList(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'location': location?.toJson(),
      'taxFee': taxFee,
      'isApproved': isApproved,
      'bookings': bookings.map((e) => e.toJson()).toList(),
    };
  }
}
