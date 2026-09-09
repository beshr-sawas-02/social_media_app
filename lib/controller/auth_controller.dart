import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/utils/app_routes.dart';

class AuthController extends GetxController {
  //this is for register info
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  bool loading = false;

  Future<void> signup() async {
    loading = true;
    update();
    try {
      var u = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      UserModel userModel = UserModel(
          username: userName.text,
          email: email.text,
          phone: phone.text,
          uid: u.user!.uid,
          image: '');
      await FirebaseFirestore.instance
          .collection("users")
          .doc(u.user!.uid)
          .set(userModel.toJson());
    }on FirebaseAuthException catch (e) {
      loading = false;
      update();
      Get.snackbar("Error", e.code);
    }
  }

  bool loginLoading = false;

  Future<void> login(String email, String password) async {
    loginLoading = true;
    update();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await getUserData(userCredential.user!.uid);
      Get.toNamed(RoutesPath.home);
    } on FirebaseAuthException catch (e) {
      loginLoading = false;
      update();
      Get.snackbar("Error", e.code);
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.code);
    }
  }

  UserModel? userModel;

  Future<void> getUserData(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .then((value) {
        userModel = UserModel.fromJson(value.data()!);
      });
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.code);
    }
  }
}
