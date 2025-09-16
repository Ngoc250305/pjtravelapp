import 'Tour.dart';
import 'TourActivity.dart';

class TourSchedule {
  final int scheduleID;
  final int dayNumber;
  final String scheduleDate;
  final String notes;
  final List<TourActivity> activities;

  TourSchedule({
    required this.scheduleID,
    required this.dayNumber,
    required this.scheduleDate,
    required this.notes,
    required this.activities,
  });

  factory TourSchedule.fromJson(Map<String, dynamic> json) => TourSchedule(
    scheduleID: json['scheduleID'],
    dayNumber: json['dayNumber'],
    scheduleDate: json['scheduleDate'],
    notes: json['notes'],
    activities: (json['activities'] as List)
        .map((e) => TourActivity.fromJson(e))
        .toList(),
  );
}
