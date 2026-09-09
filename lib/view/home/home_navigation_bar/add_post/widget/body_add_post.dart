import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';

class BodyAddPost extends StatelessWidget {
  const BodyAddPost({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller=Get.put(HomeController());
    return Expanded(
      child: SingleChildScrollView(
        child: TextField(
          controller: controller.caption,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: "What are you thinking now ?",
            fillColor: Colors.grey.shade300
          ),
        ),
      ),
    );
  }
}
