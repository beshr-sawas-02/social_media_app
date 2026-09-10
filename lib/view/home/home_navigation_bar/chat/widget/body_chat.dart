import 'package:flutter/material.dart';
import 'package:social_media_app/models/messagemodel.dart';
import 'package:social_media_app/models/user_model.dart';

/// Legacy widget. Chat UI lives in ChatNavScreen / ChatConversationScreen.
class BodyChat extends StatelessWidget {
  final UserModel user;
  final MessageModel messageModel;
  const BodyChat({super.key, required this.user, required this.messageModel});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
