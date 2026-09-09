import 'package:flutter/material.dart';
import 'package:social_media_app/models/user_model.dart';


class HeaderChat extends StatelessWidget {
  final UserModel user;
  const HeaderChat({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(user.image),
        ),
        Text(user.username),
      ],
    );
  }
}
