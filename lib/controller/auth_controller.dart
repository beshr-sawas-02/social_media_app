import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/utils/app_routes.dart';

class AuthController extends GetxController {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  bool loading = false;
  bool loginLoading = false;
  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    update();
  }

  bool _validEmail(String value) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim());
  }

  Future<void> signup() async {
    final name = userName.text.trim();
    final mail = email.text.trim();
    final pass = password.text.trim();

    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter a username');
      return;
    }
    if (!_validEmail(mail)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }
    if (pass.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    loading = true;
    update();
    try {
      final u = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: pass,
      );
      final created = UserModel(
        username: name,
        email: mail,
        phone: phone.text.trim(),
        uid: u.user!.uid,
        image: '',
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(u.user!.uid)
          .set(created.toJson());
      userModel = created;
      loading = false;
      update();
      Get.offAllNamed(RoutesPath.home);
    } on FirebaseAuthException catch (e) {
      loading = false;
      update();
      Get.snackbar('Error', e.message ?? e.code);
    } catch (e) {
      loading = false;
      update();
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> login(String emailInput, String passwordInput) async {
    final mail = emailInput.trim();
    final pass = passwordInput.trim();

    if (!_validEmail(mail)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }
    if (pass.isEmpty) {
      Get.snackbar('Error', 'Please enter your password');
      return;
    }

    loginLoading = true;
    update();
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: pass);
      await getUserData(userCredential.user!.uid);
      loginLoading = false;
      update();
      Get.offAllNamed(RoutesPath.home);
    } on FirebaseAuthException catch (e) {
      loginLoading = false;
      update();
      Get.snackbar('Error', e.message ?? e.code);
    } on FirebaseException catch (e) {
      loginLoading = false;
      update();
      Get.snackbar('Error', e.message ?? e.code);
    } catch (e) {
      loginLoading = false;
      update();
      Get.snackbar('Error', e.toString());
    }
  }

  UserModel? userModel;

  Future<void> getUserData(String uid) async {
    try {
      final value =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = value.data();
      if (data == null) {
        Get.snackbar('Error', 'User data not found');
        return;
      }
      userModel = UserModel.fromJson(data);
      update();
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message ?? e.code);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    userModel = null;
    Get.offAllNamed(RoutesPath.login);
  }
}
