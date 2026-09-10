import 'package:flutter/material.dart';
import 'package:social_media_app/models/user_model.dart';

/// Legacy widget. Chat UI lives in ChatNavScreen / ChatConversationScreen.
class HeaderChat extends StatelessWidget {
  final UserModel user;
  const HeaderChat({super.key, required this.user});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
