import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/models/messagemodel.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/utils/icons.dart';
import 'package:social_media_app/view/home/home_navigation_bar/chat/widget/header_chat.dart';

import 'widget/body_chat.dart';

class ChatNavScreen extends StatelessWidget {
   ChatNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder:(controller) =>  SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Center(
                child: Text(
                  "Chat",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          AppIcons.search,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "Search",
                        fillColor: Colors.grey.shade300,
                        filled: true),
                  ),
                ),
              ),
              SizedBox(
                height: 90,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      UserModel user=controller.users[index];
                      return HeaderChat(user: user,);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 15,
                      );
                    },
                    itemCount: controller.users.length),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("chats").snapshots(),
                builder: (context, snapshot) {
                  return ListView.separated(
                      physics:  NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        UserModel? user;
                        controller.users.forEach((u) {
                          if(u.uid==snapshot.data!.docs[index].id){
                            user=u;
                          }
                        });
                        List<MessageModel> messages=[];
                        List mapMessages= snapshot.data?.docs[index].get("messages");
                        mapMessages.forEach((element) {
                          MessageModel m=MessageModel.fromJson(element);
                          messages.add(m);
                        });
                        return InkWell(
                          onTap: () {},
                          child:  Padding(
                            padding: EdgeInsets.only(
                              top: 8.0,
                            ),
                            child: BodyChat(user: user!, messageModel: messages.last,),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: snapshot.data?.docs.length ?? 0);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
