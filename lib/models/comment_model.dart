import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userId;
  final String username;
  final String userImage;
  final Timestamp date;
  final String comment;

  CommentModel({
    required this.userId,
    required this.date,
    required this.comment,
    this.username = '',
    this.userImage = '',
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date'];
    return CommentModel(
      userId: json['userId']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      userImage: json['userImage']?.toString() ?? '',
      date: rawDate is Timestamp ? rawDate : Timestamp.now(),
      comment: json['comment']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "username": username,
      "userImage": userImage,
      "date": date,
      "comment": comment,
    };
  }
}
