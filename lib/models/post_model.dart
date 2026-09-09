import 'package:social_media_app/models/comment_model.dart';

class PostModel {
  final String userId;
  final String photo;
  final String caption;
  final List tag;
  final String id;
  final String date;
  List? likes = [];
  List<CommentModel>? comment = [];

  PostModel(
      {required this.userId,
      required this.photo,
      required this.caption,
      required this.tag,
      required this.id,
      required this.date,
      this.likes,
      this.comment});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<CommentModel> comments = [];
    List c = json['comments'];
    c.forEach((element) {
      comments.add(CommentModel.fromJson(element));
    });
    return PostModel(
      userId: json['userId'],
      photo: json['photo'],
      caption: json['caption'],
      tag: json['tag'],
      id: json['id'],
      date: json['date'],
      likes: json['likes'],
      comment: comments,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> comments = [];
    comment?.forEach((element) {
      comments.add(element.toJson());
    });
    return {
      "userId": userId,
      "photo": photo,
      "caption": caption,
      "tag": tag,
      "id": id,
      "date": date,
      "likes": likes ?? [],
      "comments": comments ?? [],
    };
  }
}
