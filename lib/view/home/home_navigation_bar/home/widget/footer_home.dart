import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/icons.dart';
import 'package:social_media_app/view/home/home_navigation_bar/home/comment_screen.dart';

class FooterPost extends StatelessWidget {
  final PostModel post;
  final HomeController controller;
  const FooterPost({super.key, required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isLiked = uid != null && post.likes.contains(uid);

    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: isLiked ? Icons.thumb_up_alt_rounded : AppIcons.like,
            label: 'Like',
            count: post.likes.length,
            color: isLiked ? AppColors.primary : AppColors.textSecondary,
            onTap: () => controller.likePost(postId: post.id),
          ),
        ),
        Expanded(
          child: _ActionButton(
            icon: AppIcons.comment,
            label: 'Comment',
            count: post.comment.length,
            color: AppColors.textSecondary,
            onTap: () => CommentsSheet.show(context, post),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 13,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
