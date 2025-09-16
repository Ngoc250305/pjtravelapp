import 'Account.dart';

class UserProfile {
  final int accountId;
  final Account account;
  final String fullName;
  final String avatarUrl;
  final String bio;
  final String gender;
  final String dateOfBirth;
  final String address;
  final String location;
  final String phone;
  final String facebook;
  final String instagram;
  final String website;

  UserProfile({
    required this.accountId,
    required this.account,
    required this.fullName,
    required this.avatarUrl,
    required this.bio,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.location,
    required this.phone,
    required this.facebook,
    required this.instagram,
    required this.website,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    accountId: json['accountId'],
    account: Account.fromJson(json['account']),
    fullName: json['fullName'],
    avatarUrl: json['avatarUrl'],
    bio: json['bio'],
    gender: json['gender'],
    dateOfBirth: json['dateOfBirth'],
    address: json['address'],
    location: json['location'],
    phone: json['phone'],
    facebook: json['facebook'],
    instagram: json['instagram'],
    website: json['website'],
  );
}
