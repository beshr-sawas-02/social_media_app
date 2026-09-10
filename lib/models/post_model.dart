import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/models/comment_model.dart';

class PostModel {
  final String userId;
  final String photo;
  final String caption;
  final List tag;
  final String id;
  final String date;
  List likes;
  List<CommentModel> comment;

  PostModel({
    required this.userId,
    required this.photo,
    required this.caption,
    required this.tag,
    required this.id,
    required this.date,
    List? likes,
    List<CommentModel>? comment,
  })  : likes = likes ?? [],
        comment = comment ?? [];

  static String parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }
    // Local optimistic write still has FieldValue before the server resolves it
    if (value == null || value is FieldValue) {
      return DateTime.now().toIso8601String();
    }
    final text = value.toString();
    if (text.isEmpty || text.contains('FieldValue')) {
      return DateTime.now().toIso8601String();
    }
    return text;
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final List commentsJson = json['comments'] is List ? json['comments'] : [];
    final List<CommentModel> comments = [];
    for (var element in commentsJson) {
      if (element is Map<String, dynamic>) {
        comments.add(CommentModel.fromJson(element));
      } else if (element is Map) {
        comments.add(CommentModel.fromJson(Map<String, dynamic>.from(element)));
      }
    }
    return PostModel(
      userId: json['userId']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      tag: json['tag'] is List ? List.from(json['tag']) : [],
      id: json['id']?.toString() ?? '',
      date: parseDate(json['date']),
      likes: json['likes'] is List ? List.from(json['likes']) : [],
      comment: comments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "photo": photo,
      "caption": caption,
      "tag": tag,
      "id": id,
      "date": date,
      "likes": likes,
      "comments": comment.map((e) => e.toJson()).toList(),
    };
  }
}
