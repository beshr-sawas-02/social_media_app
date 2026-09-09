import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/utils/icons.dart';
import 'package:social_media_app/view/home/home_navigation_bar/home/comment_screen.dart';
import 'package:social_media_app/widgets/footer_text_with_icon.dart';

class FooterPost extends StatelessWidget {
  final PostModel post;
  final HomeController controller;
  const FooterPost({super.key, required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FooterTextWithIcon(
            icon: AppIcons.like,
            text: "Like",
            color: post.likes!.contains(FirebaseAuth.instance.currentUser!.uid) ? Colors.blue : Colors.grey,
            onPressed: () async {
             await controller.likePost(postId: post.id);
          },
          ),
        ),
        Expanded(
          child: FooterTextWithIcon(
            icon: AppIcons.comment,
            text: "Comment",
            color: Colors.black,
            onPressed: () async {
              Get.to(CommentScreen(postModel: post,),transition: Transition.downToUp,duration: Duration(seconds: 2));
             await controller.commentPost(postId: post.id, comment: "beshr");
          },
          ),
        ),
      ],
    );
  }
}
