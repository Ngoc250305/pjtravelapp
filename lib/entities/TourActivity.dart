import 'TourExpense.dart';

class TourActivity {
  final int activityID;
  final String timeFrom;
  final String timeTo;
  final String title;
  final String description;
  final String location;
  final List<TourExpense> expenses;

  TourActivity({
    required this.activityID,
    required this.timeFrom,
    required this.timeTo,
    required this.title,
    required this.description,
    required this.location,
    required this.expenses,
  });

  factory TourActivity.fromJson(Map<String, dynamic> json) => TourActivity(
    activityID: json['activityID'],
    timeFrom: json['timeFrom'],
    timeTo: json['timeTo'],
    title: json['title'],
    description: json['description'],
    location: json['location'],
    expenses: (json['expenses'] as List)
        .map((e) => TourExpense.fromJson(e))
        .toList(),
  );
}
