import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/utils/app_images.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/date_utils.dart';
import 'package:social_media_app/utils/icons.dart';

class HeaderPost extends StatelessWidget {
  final PostModel post;
  const HeaderPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final UserModel? user = controller.findUser(post.userId);
    final name = (user?.username.isNotEmpty ?? false)
        ? user!.username
        : 'User';
    final ImageProvider avatar = (user?.image.isNotEmpty ?? false)
        ? NetworkImage(user!.image) as ImageProvider
        : AssetImage(AppImages.profile);

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.divider,
          backgroundImage: avatar,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (user != null) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                formatRelativeTime(post.date),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          visualDensity: VisualDensity.compact,
          icon: Icon(AppIcons.more, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
