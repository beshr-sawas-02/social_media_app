import 'package:flutter/material.dart';
import 'package:social_media_app/utils/icons.dart';

class FooterProfile extends StatelessWidget {
  const FooterProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: OutlinedButton(
            style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(color: Colors.grey.shade300)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                ))),
            onPressed: () {},
            child: Text("Add Post"),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: OutlinedButton(
            style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(color: Colors.grey.shade300)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                ))),
            onPressed: () {},
            child: Icon(
                AppIcons.edit
            ),
          ),
        ),
      ],
    );;
  }
}
