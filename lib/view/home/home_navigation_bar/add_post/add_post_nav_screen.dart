import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/view/home/home_navigation_bar/add_post/widget/body_add_post.dart';
import 'package:social_media_app/view/home/home_navigation_bar/add_post/widget/footer_add_post.dart';
import 'package:social_media_app/view/home/home_navigation_bar/add_post/widget/header_add_post.dart';

class AddPostNavScreen extends StatelessWidget {
  const AddPostNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder: (controller) => Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Creat Post",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 15.0,
                        left: 8.0,
                        bottom: 8.0,
                        top: 8.0,
                      ),
                      child: Text.rich(
                        TextSpan(
                            text: "Post",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await controller.addPost();
                              },
                            style: const TextStyle(
                              color: Colors.purple,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
                right: 8.0,
                left: 8.0,
              ),
              child: HeaderAddPost(),
            ),
            BodyAddPost(),
            if (controller.image != null)
              Image.file(
                controller.image!,
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
              ),
            FooterAddPost(),
          ],
        ),
      ),
    );
  }
}
