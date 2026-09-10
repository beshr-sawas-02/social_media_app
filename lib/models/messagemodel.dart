import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final Timestamp date;
  final bool isSender;

  MessageModel({
    required this.message,
    required this.date,
    required this.isSender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date'];
    return MessageModel(
      message: json['message']?.toString() ?? '',
      date: rawDate is Timestamp ? rawDate : Timestamp.now(),
      isSender: json['isSender'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'date': date,
      'isSender': isSender,
    };
  }
}
