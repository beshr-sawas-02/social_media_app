import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/models/messagemodel.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/utils/app_images.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/date_utils.dart';
import 'package:social_media_app/view/home/home_navigation_bar/chat/chat_conversation_screen.dart';
import 'package:social_media_app/widgets/app_ui.dart';

class ChatNavScreen extends StatefulWidget {
  const ChatNavScreen({super.key});

  @override
  State<ChatNavScreen> createState() => _ChatNavScreenState();
}

class _ChatNavScreenState extends State<ChatNavScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(HomeController()).getAllUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ImageProvider _avatar(UserModel user) {
    if (user.image.trim().isNotEmpty) {
      return NetworkImage(user.image);
    }
    return AssetImage(AppImages.profile);
  }

  void _openChat(UserModel user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatConversationScreen(peer: user),
      ),
    );
  }

  List<MessageModel> _parseMessages(List? raw) {
    final list = <MessageModel>[];
    for (final e in raw ?? []) {
      if (e is Map<String, dynamic>) {
        list.add(MessageModel.fromJson(e));
      } else if (e is Map) {
        list.add(MessageModel.fromJson(Map<String, dynamic>.from(e)));
      }
    }
    return list;
  }

  bool _matches(UserModel user) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return user.username.toLowerCase().contains(q) ||
        user.email.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final myUid = FirebaseAuth.instance.currentUser?.uid;

    return GetBuilder<HomeController>(
      builder: (controller) {
        final people = controller.otherUsers.where(_matches).toList();

        return AppPageBackground(
          child: Column(
            children: [
              const AppTopBar(
                title: 'Chat',
                subtitle: 'Messages & people',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.trim()),
                  decoration: const InputDecoration(
                    hintText: 'Search people...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: myUid == null
                    ? const Center(
                        child: Text(
                          'Please login to use chat',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                              child: Row(
                                children: [
                                  const Text(
                                    'People',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${people.length}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (people.isEmpty)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'No users found',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 100,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: people.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    final user = people[index];
                                    return InkWell(
                                      onTap: () => _openChat(user),
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        width: 72,
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: AppColors.divider,
                                              backgroundImage: _avatar(user),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              user.username.isEmpty
                                                  ? 'User'
                                                  : user.username,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Text(
                                'Messages',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(myUid)
                                .collection('chats')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting &&
                                  !snapshot.hasData) {
                                return const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final docs = List<
                                  QueryDocumentSnapshot<
                                      Map<String, dynamic>>>.from(
                                snapshot.data?.docs ?? [],
                              );

                              docs.sort((a, b) {
                                final aUpdated = a.data()['updatedAt'];
                                final bUpdated = b.data()['updatedAt'];
                                final aDate = aUpdated is Timestamp
                                    ? aUpdated.toDate()
                                    : DateTime(1970);
                                final bDate = bUpdated is Timestamp
                                    ? bUpdated.toDate()
                                    : DateTime(1970);
                                return bDate.compareTo(aDate);
                              });

                              final filtered = docs.where((doc) {
                                final user = controller.findUser(doc.id) ??
                                    UserModel(
                                      username: 'User',
                                      email: '',
                                      phone: '',
                                      uid: doc.id,
                                      image: '',
                                    );
                                return _matches(user);
                              }).toList();

                              if (filtered.isEmpty) {
                                return const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(24, 20, 24, 40),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_outline_rounded,
                                          size: 40,
                                          color: AppColors.textSecondary,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'No conversations yet',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Tap a person above to start chatting.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return SliverPadding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 20),
                                sliver: SliverList.separated(
                                  itemCount: filtered.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final doc = filtered[index];
                                    final user = controller.findUser(doc.id) ??
                                        UserModel(
                                          username: 'User',
                                          email: '',
                                          phone: '',
                                          uid: doc.id,
                                          image: '',
                                        );
                                    final messages = _parseMessages(
                                      doc.data()['messages'] as List?,
                                    );
                                    final last = messages.isNotEmpty
                                        ? messages.last
                                        : null;

                                    return Material(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(16),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () => _openChat(user),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundColor:
                                                    AppColors.divider,
                                                backgroundImage: _avatar(user),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            user.username
                                                                    .isEmpty
                                                                ? 'User'
                                                                : user.username,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .textPrimary,
                                                            ),
                                                          ),
                                                        ),
                                                        if (last != null)
                                                          Text(
                                                            formatRelativeDateTime(
                                                              last.date
                                                                  .toDate(),
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 11.5,
                                                              color: AppColors
                                                                  .textSecondary,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      last == null
                                                          ? 'No messages yet'
                                                          : (last.isSender
                                                              ? 'You: ${last.message}'
                                                              : last.message),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: AppColors
                                                            .textSecondary,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              const Icon(
                                                Icons.chevron_right_rounded,
                                                color: AppColors.textSecondary,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
