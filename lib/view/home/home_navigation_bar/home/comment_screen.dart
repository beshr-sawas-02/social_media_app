import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/utils/app_images.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/date_utils.dart';

/// Facebook-style comments: slides up as a draggable sheet over the feed.
class CommentsSheet {
  static Future<void> show(BuildContext context, PostModel post) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => CommentsSheetView(postModel: post),
    );
  }
}

class CommentsSheetView extends StatefulWidget {
  const CommentsSheetView({super.key, required this.postModel});

  final PostModel postModel;

  @override
  State<CommentsSheetView> createState() => _CommentsSheetViewState();
}

class _CommentsSheetViewState extends State<CommentsSheetView> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit(HomeController controller) async {
    final text = _commentController.text.trim();
    if (text.isEmpty || controller.isCommenting) return;

    final ok = await controller.commentPost(
      postId: widget.postModel.id,
      comment: text,
    );
    if (!ok || !mounted) return;
    _commentController.clear();
  }

  List<CommentModel> _parseComments(List raw) {
    final comments = <CommentModel>[];
    for (final element in raw) {
      if (element is Map<String, dynamic>) {
        comments.add(CommentModel.fromJson(element));
      } else if (element is Map) {
        comments.add(CommentModel.fromJson(Map<String, dynamic>.from(element)));
      }
    }
    return comments;
  }

  String _displayName(CommentModel comment, HomeController controller) {
    if (comment.username.trim().isNotEmpty) return comment.username.trim();
    final UserModel? user = controller.findUser(comment.userId);
    if (user != null && user.username.trim().isNotEmpty) {
      return user.username.trim();
    }
    return 'User';
  }

  ImageProvider _avatar(CommentModel comment, HomeController controller) {
    if (comment.userImage.trim().isNotEmpty) {
      return NetworkImage(comment.userImage);
    }
    final UserModel? user = controller.findUser(comment.userId);
    if (user != null && user.image.trim().isNotEmpty) {
      return NetworkImage(user.image);
    }
    return AssetImage(AppImages.profile);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return GetBuilder<HomeController>(
      builder: (controller) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.only(bottom: keyboard),
          child: DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.45,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
                      child: Row(
                        children: [
                          const SizedBox(width: 40),
                          const Expanded(
                            child: Text(
                              'Comments',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    Expanded(
                      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postModel.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return ListView(
                              controller: scrollController,
                              children: const [
                                SizedBox(height: 80),
                                _CommentsEmpty(
                                  icon: Icons.error_outline_rounded,
                                  title: 'Could not load comments',
                                  subtitle:
                                      'Check your connection and try again.',
                                ),
                              ],
                            );
                          }

                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              !snapshot.hasData) {
                            return ListView(
                              controller: scrollController,
                              children: const [
                                SizedBox(height: 100),
                                Center(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          final comments = _parseComments(
                            (snapshot.data?.data()?['comments'] as List?) ??
                                [],
                          );

                          if (comments.isEmpty) {
                            return ListView(
                              controller: scrollController,
                              children: const [
                                SizedBox(height: 40),
                                _CommentsEmpty(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  title: 'No comments yet',
                                  subtitle:
                                      'Be the first to share your thoughts.',
                                ),
                              ],
                            );
                          }

                          return ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            itemCount: comments.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return _CommentTile(
                                name: _displayName(comment, controller),
                                avatar: _avatar(comment, controller),
                                text: comment.comment,
                                time: formatRelativeDateTime(
                                  comment.date.toDate(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    _CommentComposer(
                      controller: _commentController,
                      focusNode: _focusNode,
                      isSending: controller.isCommenting,
                      onSend: () => _submit(controller),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.name,
    required this.avatar,
    required this.text,
    required this.time,
  });

  final String name;
  final ImageProvider avatar;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.divider,
          backgroundImage: avatar,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.35,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentComposer extends StatelessWidget {
  const _CommentComposer({
    required this.controller,
    required this.focusNode,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.divider,
              backgroundImage: AssetImage(AppImages.profile),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                enabled: !isSending,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: isSending ? null : onSend,
              icon: isSending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: AppColors.primary,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentsEmpty extends StatelessWidget {
  const _CommentsEmpty({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
