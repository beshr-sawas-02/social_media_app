import 'package:flutter/material.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/utils/app_images.dart';
import 'package:social_media_app/utils/icons.dart';

class HeaderPost extends StatelessWidget {
  final PostModel post;
  const HeaderPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
            left: 8.0,
            top: 5.0,
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(AppImages.profile),
          ),
        ),
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "beshr sawas",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                ),
              ],
            ),
            Text(
              post.date.toString(),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(
            8.0,
          ),
          child: Icon(
            AppIcons.more,
          ),
        ),
      ],
    );
  }
}
