import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/auth_controller.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/view/auth/widgets/auth_shared.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return AuthAtmosphere(
      tagline: 'Join the community in seconds.',
      child: AuthGlassCard(
        child: GetBuilder<AuthController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F0FA),
                        ),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Create account',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Build your presence. Share moments. Meet people.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  AuthTextField(
                    controller: authController.userName,
                    label: 'Username',
                    hint: 'Your display name',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: authController.email,
                    label: 'Email',
                    hint: 'you@email.com',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: authController.password,
                    label: 'Password',
                    hint: 'At least 6 characters',
                    icon: Icons.lock_outline_rounded,
                    obscureText: controller.obscurePassword,
                    suffix: IconButton(
                      onPressed: controller.togglePasswordVisibility,
                      icon: Icon(
                        controller.obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: authController.phone,
                    label: 'Phone',
                    hint: 'Optional phone number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  AuthPrimaryButton(
                    label: 'Create Account',
                    loading: controller.loading,
                    onPressed: controller.signup,
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text(
                          'Already a member? ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
