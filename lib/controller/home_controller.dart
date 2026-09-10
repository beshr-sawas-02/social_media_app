import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    if (value == 1) {
      getAllUsers();
    }
    if (value == 2 && currentProfile == null) {
      loadProfile();
    }
    if (value == 3) {
      loadProfile();
    }
  }

  List<Widget> pages = [
    const HomeNavScreen(),
    const ChatNavScreen(),
    const AddPostNavScreen(),
    const ProfileNavScreen(),
  ];

  ImagePicker imagePicker = ImagePicker();
  File? image;
  bool isPosting = false;

  Future<void> pickPostImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final file = await imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (file == null) return;
      image = File(file.path);
      update();
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Could not open gallery/camera');
    }
  }

  void clearPostImage() {
    image = null;
    update();
  }

  /// Legacy alias used by older widgets.
  Future<void> getImage() => pickPostImage();

  Future<String?> uploadImage() async {
    if (image == null) return null;
    try {
      final user = FirebaseAuth.instance.currentUser;
      final name =
          '${user?.uid ?? 'guest'}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child('uploads/$name');
      await storageRef.putFile(image!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  TextEditingController caption = TextEditingController();

  List<String> extractHashtags(String text) {
    final matches = RegExp(r'#(\w+)').allMatches(text);
    return matches
        .map((m) => m.group(1)!)
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList();
  }

  String captionWithoutHashtags(String text) {
    return text.replaceAll(RegExp(r'#\w+'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<void> addPost() async {
    if (isPosting) return;

    if (image == null) {
      Get.snackbar('Error', 'Please select an image');
      return;
    }

    final rawCaption = caption.text.trim();
    if (rawCaption.isEmpty) {
      Get.snackbar('Error', 'Please write a caption');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Please login first');
      return;
    }

    isPosting = true;
    update();

    try {
      final url = await uploadImage();
      if (url == null) {
        Get.snackbar(
          'Error',
          'Failed to upload image. Enable Firebase Blaze for Storage.',
        );
        return;
      }

      final tags = extractHashtags(rawCaption);
      final cleanCaption = captionWithoutHashtags(rawCaption);
      final ref = FirebaseFirestore.instance.collection('posts').doc();
      final post = PostModel(
        userId: user.uid,
        photo: url,
        caption: cleanCaption.isEmpty ? rawCaption : cleanCaption,
        tag: tags,
        id: ref.id,
        date: '',
      );
      final data = post.toJson();
      data['date'] = FieldValue.serverTimestamp();
      await ref.set(data);

      image = null;
      caption.clear();
      update();
      getIndex(0);
      Get.snackbar('Success', 'Post published');
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isPosting = false;
      update();
    }
  }

  bool isSendingMessage = false;

  Future<bool> sendMessage({
    required String message,
    required String receiverId,
  }) async {
    final text = message.trim();
    if (text.isEmpty) return false;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Please login first');
      return false;
    }
    if (receiverId.isEmpty || receiverId == user.uid) return false;

    isSendingMessage = true;
    update();

    try {
      final now = Timestamp.now();
      final myChat = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(receiverId);
      final theirChat = FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final mySnap = await transaction.get(myChat);
        final theirSnap = await transaction.get(theirChat);

        final myMessages = <Map<String, dynamic>>[];
        for (final e in (mySnap.data()?['messages'] as List? ?? [])) {
          if (e is Map) myMessages.add(Map<String, dynamic>.from(e));
        }
        final theirMessages = <Map<String, dynamic>>[];
        for (final e in (theirSnap.data()?['messages'] as List? ?? [])) {
          if (e is Map) theirMessages.add(Map<String, dynamic>.from(e));
        }

        myMessages.add(
          MessageModel(message: text, date: now, isSender: true).toJson(),
        );
        theirMessages.add(
          MessageModel(message: text, date: now, isSender: false).toJson(),
        );

        transaction.set(
          myChat,
          {
            'messages': myMessages,
            'updatedAt': now,
            'peerId': receiverId,
          },
          SetOptions(merge: true),
        );
        transaction.set(
          theirChat,
          {
            'messages': theirMessages,
            'updatedAt': now,
            'peerId': user.uid,
          },
          SetOptions(merge: true),
        );
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Could not send message');
      return false;
    } finally {
      isSendingMessage = false;
      update();
    }
  }

  List<UserModel> get otherUsers {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return users;
    return users.where((u) => u.uid != uid).toList();
  }

  List<UserModel> users = [];

  UserModel? findUser(String uid) {
    for (final user in users) {
      if (user.uid == uid) return user;
    }
    return null;
  }

  getAllUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> usersDocs =
          await FirebaseFirestore.instance.collection("users").get();
      users = [];
      for (var element in usersDocs.docs) {
        UserModel u = UserModel.fromJson(element.data());
        users.add(u);
      }
      update();
    } catch (e) {
      debugPrint(e.toString());
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
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      DocumentSnapshot post = await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .get();
      final data = post.data() as Map<String, dynamic>?;
      List<String> likes = List<String>.from(data?['likes'] ?? []);
      if (likes.contains(user.uid)) {
        likes.remove(user.uid);
      } else {
        likes.add(user.uid);
      }
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .update({"likes": likes});
      update();
    } catch (e) {
      Get.snackbar("Error", "No Internet",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  bool isCommenting = false;

  Future<bool> commentPost({
    required String postId,
    required String comment,
  }) async {
    final text = comment.trim();
    if (text.isEmpty) return false;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Please login first');
      return false;
    }

    final profile = findUser(user.uid);
    isCommenting = true;
    update();

    try {
      final commentModel = CommentModel(
        userId: user.uid,
        username: profile?.username.isNotEmpty == true
            ? profile!.username
            : (user.email?.split('@').first ?? 'User'),
        userImage: profile?.image ?? '',
        date: Timestamp.now(),
        comment: text,
      );

      final ref = FirebaseFirestore.instance.collection('posts').doc(postId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snap = await transaction.get(ref);
        if (!snap.exists) {
          throw Exception('Post not found');
        }
        final comments = <Map<String, dynamic>>[];
        for (final e in (snap.data()?['comments'] as List? ?? [])) {
          if (e is Map<String, dynamic>) {
            comments.add(Map<String, dynamic>.from(e));
          } else if (e is Map) {
            comments.add(Map<String, dynamic>.from(e));
          }
        }
        comments.add(commentModel.toJson());
        transaction.update(ref, {'comments': comments});
      });
      update();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        'Error',
        'Could not post comment',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isCommenting = false;
      update();
    }
  }


  UserModel? currentProfile;
  List<PostModel> myPosts = [];
  bool profileLoading = false;
  bool profileSaving = false;

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    profileLoading = true;
    update();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data() != null) {
        currentProfile = UserModel.fromJson(doc.data()!);
      } else {
        currentProfile = UserModel(
          username: user.email?.split('@').first ?? 'User',
          email: user.email ?? '',
          phone: '',
          uid: user.uid,
          image: '',
        );
      }

      final postsSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: user.uid)
          .get();

      myPosts = postsSnap.docs
          .map((e) => PostModel.fromJson(e.data()))
          .toList();

      myPosts.sort((a, b) {
        final da = DateTime.tryParse(a.date) ?? DateTime(1970);
        final db = DateTime.tryParse(b.date) ?? DateTime(1970);
        return db.compareTo(da);
      });

      // keep users cache in sync for feed headers
      final idx = users.indexWhere((u) => u.uid == user.uid);
      if (currentProfile != null) {
        if (idx >= 0) {
          users[idx] = currentProfile!;
        } else {
          users.add(currentProfile!);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Could not load profile');
    } finally {
      profileLoading = false;
      update();
    }
  }

  int get myPostsCount => myPosts.length;

  int get myLikesCount {
    var total = 0;
    for (final post in myPosts) {
      total += post.likes.length;
    }
    return total;
  }

  Future<bool> updateProfile({
    required String username,
    required String phone,
    required String bio,
    String? imageUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    profileSaving = true;
    update();

    try {
      final updated = (currentProfile ??
              UserModel(
                username: username,
                email: user.email ?? '',
                phone: phone,
                uid: user.uid,
                image: '',
              ))
          .copyWith(
        username: username.trim(),
        phone: phone.trim(),
        bio: bio.trim(),
        image: imageUrl ?? currentProfile?.image,
        email: user.email ?? currentProfile?.email ?? '',
        uid: user.uid,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(updated.toJson(), SetOptions(merge: true));

      currentProfile = updated;
      final idx = users.indexWhere((u) => u.uid == user.uid);
      if (idx >= 0) {
        users[idx] = updated;
      } else {
        users.add(updated);
      }
      update();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Could not update profile');
      return false;
    } finally {
      profileSaving = false;
      update();
    }
  }

  Future<String?> uploadProfileImage() async {
    final picked = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked == null) return null;
    image = File(picked.path);
    return uploadImage();
  }

  Future<void> logout() async {
    currentProfile = null;
    myPosts = [];
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }

  @override
  void onInit() {
    super.onInit();
    getAllUsers();
  }
}
