import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/icons.dart';
import 'package:social_media_app/widgets/app_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder: (controller) {
        return AppPageBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: controller.pages[controller.value],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: NavigationBar(
                height: 70,
                backgroundColor: Colors.transparent,
                elevation: 0,
                indicatorColor: AppColors.primary.withValues(alpha: 0.14),
                selectedIndex: controller.value,
                onDestinationSelected: controller.getIndex,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: [
                  NavigationDestination(
                    icon: Icon(AppIcons.home, color: AppColors.textSecondary),
                    selectedIcon:
                        Icon(AppIcons.home, color: AppColors.primary),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(AppIcons.chat, color: AppColors.textSecondary),
                    selectedIcon:
                        Icon(AppIcons.chat, color: AppColors.primary),
                    label: 'Chat',
                  ),
                  NavigationDestination(
                    icon:
                        Icon(AppIcons.addPost, color: AppColors.textSecondary),
                    selectedIcon:
                        Icon(AppIcons.addPost, color: AppColors.primary),
                    label: 'Add',
                  ),
                  NavigationDestination(
                    icon:
                        Icon(AppIcons.person, color: AppColors.textSecondary),
                    selectedIcon:
                        Icon(AppIcons.person, color: AppColors.primary),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
