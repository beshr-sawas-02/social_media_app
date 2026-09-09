import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/models/messagemodel.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/view/home/home_navigation_bar/add_post/add_post_nav_screen.dart';
import 'package:social_media_app/view/home/home_navigation_bar/chat/chat_nav_screen.dart';
import 'package:social_media_app/view/home/home_navigation_bar/home/home_nav_screen.dart';
import 'package:social_media_app/view/home/home_navigation_bar/profile/profile_nav_screen.dart';

class HomeController extends GetxController {
  int value = 0;

  void getIndex(int value) {
    this.value = value;
    update();
  }

  List<Widget> pages = [
    const HomeNavScreen(),
    ChatNavScreen(),
    AddPostNavScreen(),
    const ProfileNavScreen(),
  ];

  ImagePicker imagePicker = ImagePicker();
  File? image;

  getImage() async {
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (file == null) {
    } else {
      image = File(file.path);
    }
    update();
  }

  Future<String?> uploadImage() async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
            'uploads/${image?.path.split('/').last}',
          );
      final uploadTask = await storageRef.putFile(image!);
      String url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  TextEditingController caption = TextEditingController();

  addPost() async {
    List<String> a = caption.text.split('#');
    try {
      String? url = await uploadImage();
      DocumentReference ref =
          await FirebaseFirestore.instance.collection("posts").doc();
      PostModel post = PostModel(
          userId: FirebaseAuth.instance.currentUser!.uid,
          photo: url!,
          caption: a[0],
          tag: a.sublist(1),
          id: ref.id,
          date: FieldValue.serverTimestamp().toString());
      await ref.set(post.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendMessage(
      {required String message, required String receiverId}) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var chat = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("chats")
        .doc(receiverId);
    await chat.get().then((value) async {
      if (!value.exists) {
        await chat.set({"messages": []});
      }
    });
    DocumentSnapshot<Map<String, dynamic>> m = await chat.get();
    List messages = m.get("messages");
    MessageModel newMessage = MessageModel(
        message: message, date: Timestamp.now(), isSender: true);
    messages.add(newMessage.toJson());
    await chat.update({"messages": messages});
    var chat2 = await FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(uid);
    await chat2.get().then((value) async {
      if (!value.exists) {
        await chat2.set({"messages": []});
      }
    });
    DocumentSnapshot<Map<String, dynamic>> m2 = await chat2.get();
    List messages2 = m2.get("messages");
    MessageModel newMessage2 = MessageModel(
        message: message, date: Timestamp.now(), isSender: false);
    messages2.add(newMessage2.toJson());
    await chat2.update({"messages": messages2});
  }

  List<UserModel> users = [];

  getAllUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> usersDocs =
          await FirebaseFirestore.instance.collection("users").get();
      usersDocs.docs.forEach((element) {
        UserModel u = UserModel.fromJson(element.data());
        users.add(u);
      });
      update();
    } catch (e) {
      print(e);
    }
  }

  List<PostModel> posts = [];

  // Future<void> getPosts() async {
  //   posts = [];
  //   try {
  //     QuerySnapshot<dynamic> data =
  //         await FirebaseFirestore.instance.collection("posts").get();
  //     data.docs.forEach((element) {
  //       PostModel post = PostModel.fromJson(element.data());
  //       posts.add(post);
  //     });
  //     update();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> likePost({required String postId}) async {
    try {
      DocumentSnapshot post = await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .get();
      List<String> likes = List<String>.from(post.get("likes"));
      String uid = FirebaseAuth.instance.currentUser!.uid;
      if (likes.contains(uid)) {
        likes.remove(uid);
      } else {
        likes.add(uid);
      }
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .update({"likes": likes});
      // await getPosts();
      update();
    } catch (e) {
      Get.snackbar("Error", "No Internet",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> commentPost(
      {required String postId, required String comment}) async {
    try {
      CommentModel commentModel = CommentModel(
        userId: FirebaseAuth.instance.currentUser!.uid,
        date: Timestamp.now(),
        comment: comment,
      );

      DocumentSnapshot<Map<String, dynamic>> post = await FirebaseFirestore
          .instance
          .collection("posts")
          .doc(postId)
          .get();
      List comments = post.get("comments");
      comments.add(commentModel.toJson());
      await FirebaseFirestore.instance.collection("posts").doc(postId).update({
        "comments": comments,
      });
      update();
    } catch (e) {
      print(e);
    }
  }


  @override
  void onInit() {
    // TODO: implement onInit
    getAllUsers();
  }



  getProfile(){
    FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).get();

  }
}
