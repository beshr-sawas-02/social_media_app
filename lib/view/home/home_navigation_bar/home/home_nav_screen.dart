import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/utils/app_images.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/view/home/home_navigation_bar/home/widget/body_home.dart';


class HomeNavScreen extends StatelessWidget {
  const HomeNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder:(controller) =>  SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.logo,
                    height: 50,
                    width: 50,
                  ),
                  const Text(
                    "AnyCode Media",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("posts").snapshots(),
              builder:(context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return CircularProgressIndicator();
                }
                return ListView.separated(
                  physics:  NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    PostModel post = PostModel.fromJson(snapshot.data!.docs[index].data());
                    return Container(
                      padding: const EdgeInsetsDirectional.all(10),
                      color: AppColors.white,
                      child:  BodyPost(post: post,),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: snapshot.data?.docs.length ?? 0,
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
