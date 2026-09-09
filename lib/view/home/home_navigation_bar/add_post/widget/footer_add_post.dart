import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/utils/icons.dart';
import 'package:social_media_app/widgets/footer_text_with_icon.dart';

class FooterAddPost extends StatelessWidget {
  const FooterAddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FooterTextWithIcon(
            icon: AppIcons.add_chart,
            text: "Add Photo",
            color: Colors.grey,
            onPressed: () {Get.put(HomeController()).getImage();},
          ),
        ),
        Expanded(
          child: FooterTextWithIcon(
            icon: AppIcons.tag,
            text: "Tag",
            color: Colors.grey,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
