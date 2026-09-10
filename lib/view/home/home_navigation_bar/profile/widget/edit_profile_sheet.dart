import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/home_controller.dart';
import 'package:social_media_app/utils/app_images.dart';
import 'package:social_media_app/utils/colors.dart';

class EditProfileSheet {
  static Future<void> show(BuildContext context, HomeController controller) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheetBody(controller: controller),
    );
  }
}

class _EditProfileSheetBody extends StatefulWidget {
  const _EditProfileSheetBody({required this.controller});

  final HomeController controller;

  @override
  State<_EditProfileSheetBody> createState() => _EditProfileSheetBodyState();
}

class _EditProfileSheetBodyState extends State<_EditProfileSheetBody> {
  late final TextEditingController username;
  late final TextEditingController phone;
  late final TextEditingController bio;
  String? pendingImageUrl;
  bool pickingImage = false;

  @override
  void initState() {
    super.initState();
    final p = widget.controller.currentProfile;
    username = TextEditingController(text: p?.username ?? '');
    phone = TextEditingController(text: p?.phone ?? '');
    bio = TextEditingController(text: p?.bio ?? '');
  }

  @override
  void dispose() {
    username.dispose();
    phone.dispose();
    bio.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => pickingImage = true);
    final url = await widget.controller.uploadProfileImage();
    if (!mounted) return;
    setState(() {
      pickingImage = false;
      if (url != null) {
        pendingImageUrl = url;
      } else {
        Get.snackbar(
          'Image',
          'Could not upload image. Check Firebase Storage / Blaze plan.',
        );
      }
    });
  }

  Future<void> _save() async {
    if (username.text.trim().isEmpty) {
      Get.snackbar('Error', 'Username is required');
      return;
    }
    final ok = await widget.controller.updateProfile(
      username: username.text,
      phone: phone.text,
      bio: bio.text,
      imageUrl: pendingImageUrl,
    );
    if (ok && mounted) {
      Navigator.pop(context);
      Get.snackbar('Success', 'Profile updated');
    }
  }

  ImageProvider get _previewAvatar {
    final url = pendingImageUrl ?? widget.controller.currentProfile?.image;
    if (url != null && url.trim().isNotEmpty) {
      return NetworkImage(url);
    }
    return AssetImage(AppImages.profile);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return GetBuilder<HomeController>(
      builder: (controller) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.only(bottom: bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Edit Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.divider,
                          backgroundImage: _previewAvatar,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Material(
                            color: AppColors.primary,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: pickingImage ? null : _pickImage,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: pickingImage
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.camera_alt_rounded,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _field(
                    controller: username,
                    label: 'Username',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: phone,
                    label: 'Phone',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: bio,
                    label: 'Bio',
                    icon: Icons.info_outline_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: controller.profileSaving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.profileSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
