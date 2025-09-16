import 'package:intl/intl.dart';
import 'TourDetail.dart';
import 'Account.dart';

class Booking {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final int people;
  final String note;
  final double totalPrice;
  final DateTime bookingDate;
  final bool paid;
  final String paymentMethod;
  final DateTime? paymentTime;
  final String status;
  final String transactionId;
  final TourDetail? tourDetail;
  final Account? account;

  Booking({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.people,
    required this.note,
    required this.totalPrice,
    required this.bookingDate,
    required this.paid,
    required this.paymentMethod,
    required this.paymentTime,
    required this.status,
    required this.transactionId,
    this.tourDetail,
    this.account,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? 0,
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      people: json['people'] ?? 0,
      note: json['note']?.toString() ?? '',
      totalPrice: (json['totalPrice'] != null)
          ? double.tryParse(json['totalPrice'].toString()) ?? 0
          : 0,
      bookingDate: DateTime.tryParse(json['bookingDate'] ?? '') ??
          DateTime.now(),
      paid: json['paid'] ?? false,
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentTime: json['paymentTime'] != null
          ? DateTime.tryParse(json['paymentTime'])
          : null,
      status: json['status']?.toString() ?? '',
      transactionId: json['transactionId']?.toString() ?? '',
      tourDetail:
      json['tourDetail'] != null ? TourDetail.fromJson(json['tourDetail']) : null,
      account:
      json['account'] != null ? Account.fromJson(json['account']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'people': people,
      'note': note,
      'totalPrice': totalPrice,
      'bookingDate': DateFormat('yyyy-MM-dd').format(bookingDate),
      'paid': paid,
      'paymentMethod': paymentMethod,
      'paymentTime': paymentTime != null
          ? DateFormat('yyyy-MM-dd').format(paymentTime!)
          : null,
      'status': status,
      'transactionId': transactionId,
      'tourDetail': tourDetail?.toJson(),
      'account': account?.toJson(),
    };
  }
}
