import 'package:flutter/material.dart';
import 'package:social_media_app/utils/app_images.dart';

class HeaderProfile extends StatelessWidget {
  const HeaderProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          AppImages.profile,
          height: 250,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          bottom: -55,
          left: (MediaQuery.of(context).size.width / 2) - 70,
          child: CircleAvatar(
            radius: 75,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage(
                AppImages.profile,
              ),
            ),
          ),
        ),
      ],
    );;
  }
}
