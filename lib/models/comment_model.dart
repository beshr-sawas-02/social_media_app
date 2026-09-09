import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userId;
  final Timestamp date;
  final String comment;

  CommentModel({
    required this.userId,
    required this.date,
    required this.comment,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userId: json['userId'],
      date: json['date'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "date": date,
      "comment": comment,
    };
  }
}
