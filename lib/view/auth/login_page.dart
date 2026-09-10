import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/auth_controller.dart';
import 'package:social_media_app/utils/app_routes.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/view/auth/widgets/auth_shared.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return AuthAtmosphere(
      child: AuthGlassCard(
        child: GetBuilder<AuthController>(
          builder: (c) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sign in to continue your story with the community.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AuthTextField(
                    controller: controller.email,
                    label: 'Email',
                    hint: 'you@email.com',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: controller.password,
                    label: 'Password',
                    hint: 'Enter your password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: c.obscurePassword,
                    suffix: IconButton(
                      onPressed: c.togglePasswordVisibility,
                      icon: Icon(
                        c.obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AuthPrimaryButton(
                    label: 'Sign In',
                    loading: c.loginLoading,
                    onPressed: () => controller.login(
                      controller.email.text,
                      controller.password.text,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Center(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(RoutesPath.signup),
                          child: const Text(
                            'Create one',
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
