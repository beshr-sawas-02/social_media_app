import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: controller.pages[controller.value],
          bottomNavigationBar: NavigationBar(
            height: 68,
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primary.withValues(alpha: 0.12),
            selectedIndex: controller.value,
            onDestinationSelected: controller.getIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: Icon(AppIcons.home, color: AppColors.textSecondary),
                selectedIcon: Icon(AppIcons.home, color: AppColors.primary),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(AppIcons.chat, color: AppColors.textSecondary),
                selectedIcon: Icon(AppIcons.chat, color: AppColors.primary),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: Icon(AppIcons.addPost, color: AppColors.textSecondary),
                selectedIcon: Icon(AppIcons.addPost, color: AppColors.primary),
                label: 'Add',
              ),
              NavigationDestination(
                icon: Icon(AppIcons.person, color: AppColors.textSecondary),
                selectedIcon: Icon(AppIcons.person, color: AppColors.primary),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
