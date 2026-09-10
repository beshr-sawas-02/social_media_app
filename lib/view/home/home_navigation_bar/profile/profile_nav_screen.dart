import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/utils/app_images.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/icons.dart';
import 'package:social_media_app/view/home/home_navigation_bar/home/comment_screen.dart';
import 'package:social_media_app/view/home/home_navigation_bar/profile/widget/edit_profile_sheet.dart';
import 'package:social_media_app/widgets/app_ui.dart';

class ProfileNavScreen extends StatefulWidget {
  const ProfileNavScreen({super.key});

  @override
  State<ProfileNavScreen> createState() => _ProfileNavScreenState();
}

class _ProfileNavScreenState extends State<ProfileNavScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(HomeController()).loadProfile();
    });
  }

  ImageProvider _avatar(UserModel? profile) {
    if (profile != null && profile.image.trim().isNotEmpty) {
      return NetworkImage(profile.image);
    }
    return AssetImage(AppImages.profile);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder: (controller) {
        final profile = controller.currentProfile;
        final name = profile?.username.isNotEmpty == true
            ? profile!.username
            : 'User';
        final bio = profile?.bio.trim().isNotEmpty == true
            ? profile!.bio
            : 'Welcome to my profile';
        final email = profile?.email ?? '';
        final phone = profile?.phone ?? '';

        return AppPageBackground(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: controller.loadProfile,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: AppTopBar(
                    title: 'Profile',
                    subtitle: 'Your space',
                    actions: [
                      IconButton(
                        tooltip: 'Logout',
                        onPressed: () => _confirmLogout(controller),
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.profileLoading && profile == null)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _ProfileHeader(
                          avatar: _avatar(profile),
                          coverUrl: profile?.coverImage ?? '',
                        ),
                        const SizedBox(height: 56),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.verified_rounded,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                bio,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  height: 1.35,
                                ),
                              ),
                              if (email.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                              if (phone.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  phone,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  _StatCard(
                                    value: '${controller.myPostsCount}',
                                    label: 'Posts',
                                  ),
                                  _StatCard(
                                    value: '${controller.myLikesCount}',
                                    label: 'Likes',
                                  ),
                                  _StatCard(
                                    value: '${controller.myPostsCount}',
                                    label: 'Photos',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppGradientButton(
                                      label: 'Add Post',
                                      icon: AppIcons.addPost,
                                      onPressed: () => controller.getIndex(2),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => EditProfileSheet.show(
                                        context,
                                        controller,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.textPrimary,
                                        side: const BorderSide(
                                          color: AppColors.divider,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      icon: Icon(AppIcons.edit, size: 18),
                                      label: const Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'My Posts',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.myPosts.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24, 20, 24, 40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              size: 42,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No posts yet',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Share your first post from Add.',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final post = controller.myPosts[index];
                            return _PostThumb(post: post);
                          },
                          childCount: controller.myPosts.length,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmLogout(HomeController controller) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (ok == true) await controller.logout();
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.avatar,
    required this.coverUrl,
  });

  final ImageProvider avatar;
  final String coverUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: coverUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(coverUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        Positioned(
          bottom: -48,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.divider,
              backgroundImage: avatar,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostThumb extends StatelessWidget {
  const _PostThumb({required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommentsSheet.show(context, post),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            post.photo.isEmpty
                ? Image.asset(AppImages.profile, fit: BoxFit.cover)
                : Image.network(
                    post.photo,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Image.asset(AppImages.profile, fit: BoxFit.cover),
                  ),
            Positioned(
              left: 6,
              bottom: 6,
              child: Row(
                children: [
                  const Icon(Icons.favorite, size: 12, color: Colors.white),
                  const SizedBox(width: 3),
                  Text(
                    '${post.likes.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
