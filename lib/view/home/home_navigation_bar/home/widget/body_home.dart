import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/icons.dart';
import 'package:social_media_app/view/home/home_navigation_bar/home/widget/footer_home.dart';
import 'package:social_media_app/view/home/home_navigation_bar/home/widget/header_home.dart';
import 'package:social_media_app/widgets/see_more.dart';

class BodyPost extends StatelessWidget {
  final PostModel post;

  const BodyPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder:(controller) => Column(
        children: [
           HeaderPost(post: post,),
          Container(
            margin: const EdgeInsets.only(
              top: 5.0,
            ),
            height: 3,
            width: double.infinity,
            color: AppColors.gray300,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpandableText(
                  text: post.caption,
                ),
              ),
              Wrap(
                children: [
                  for (int i = 0; i <post.tag.length; i++)
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "${post.tag[i]}",
                      ),
                    ),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Image.network(post.photo),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  AppIcons.heart,
                  color: AppColors.red,
                ),
                 Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text("${post.likes?.length ?? 0}"),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text("${post.comment?.length ??0}"),
                )
              ],
            ),
          ),
          Container(
            height: 3,
            width: double.infinity,
            color: Colors.grey[300],
          ),
           Padding(
            padding: EdgeInsets.all(8.0),
            child: FooterPost(post: post, controller: HomeController(),),
          )
        ],
      ),
    );
  }
}
