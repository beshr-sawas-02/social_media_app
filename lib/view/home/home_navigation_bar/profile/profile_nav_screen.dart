import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/utils/icons.dart';
import 'package:social_media_app/view/home/home_navigation_bar/profile/widget/body_profile.dart';
import 'package:social_media_app/view/home/home_navigation_bar/profile/widget/footer_profile.dart';
import 'package:social_media_app/view/home/home_navigation_bar/profile/widget/header_profile.dart';

class ProfileNavScreen extends StatelessWidget {
  const ProfileNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "News Feed",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Icon(
                    AppIcons.alarm,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Icon(
                    AppIcons.search,
                    size: 30,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,),
            HeaderProfile(),
            SizedBox(
              height: 50,
            ),
            BodyProfile(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
                child: FooterProfile()),
          ],
        ),
      ),
    );
  }
}
