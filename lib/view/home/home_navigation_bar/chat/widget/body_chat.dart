import 'package:flutter/material.dart';
import 'package:social_media_app/models/messagemodel.dart';
import 'package:social_media_app/models/user_model.dart';

class BodyChat extends StatelessWidget {
  final UserModel user;
  final MessageModel messageModel;
  const BodyChat({super.key, required this.user, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.image),
              ),
              const Positioned(
                right: 2,
                bottom: 2,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.green,
                ),

              ),
            ],
          ),
        ),
         Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username,
                style: TextStyle(),
              ),
              Row(
                children: [
                  Text(
                    messageModel.message,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      messageModel.date.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
