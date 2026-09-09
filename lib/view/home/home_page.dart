import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/utils/icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return SafeArea(
      child: GetBuilder<HomeController>(
        builder: (controller) {

          return Scaffold(
            backgroundColor: Colors.grey[400],
            body: controller.pages[controller.value],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.purple,
              unselectedItemColor: Colors.grey,
              currentIndex: controller.value,
              onTap: (value) {
                controller.getIndex(value);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(AppIcons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(AppIcons.chat),
                  label: "Chat",
                ),
                BottomNavigationBarItem(
                  icon: Icon(AppIcons.add_post),
                  label: "Add Post",
                ),
                BottomNavigationBarItem(
                  icon: Icon(AppIcons.person),
                  label: "Profile",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
