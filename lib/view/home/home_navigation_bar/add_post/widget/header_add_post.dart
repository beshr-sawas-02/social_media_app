import 'package:flutter/material.dart';
import 'package:social_media_app/utils/app_images.dart';

class HeaderAddPost extends StatelessWidget {
  const HeaderAddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(AppImages.profile),
          ),
        ),
        const Padding(
          padding:  EdgeInsets.only(
            left: 8.0,
          ),
          child: Text(
            "Beshr Sawas",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
