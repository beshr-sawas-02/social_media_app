import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/models/post_model.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen({super.key, required this.postModel});

  final PostModel postModel;
  TextEditingController comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .doc(postModel.id)
                    .snapshots(),
                builder: (context, snapshot) => ListView.separated(
                    itemBuilder: (context, index) {
                      CommentModel comment = CommentModel.fromJson(
                          snapshot.data!.get("comments")[index]);
                      return Column(
                        children: [
                          Text(comment.comment),
                          Text(comment.date.toString())
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: snapshot.data?.get("comments").length ?? 0),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: comment,
                    decoration: InputDecoration(
                        hintText: "Enter your comment",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      controller.commentPost(
                          postId: postModel.id, comment: comment.text);
                      comment.clear();
                    },
                    icon: Icon(Icons.send))
              ],
            )
          ],
        ),
      ),
    );
  }
}
