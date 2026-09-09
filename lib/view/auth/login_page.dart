import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/auth_controller.dart';
import 'package:social_media_app/view/auth/signup.dart';
import 'package:social_media_app/widgets/custom_buttom.dart';
import 'package:social_media_app/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthController controller=Get.put(AuthController());
    return  SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Welcome To Our App" ,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Colors.purple.shade900,
                fontWeight: FontWeight.bold,
              ),
              ),
              Text(
                  "Sign In Now and enjoyed",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.purple.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTextField(
                label: "Email",
                hint: "Enter Your Email",
                controller: email,
                prefixIcon: Icons.person,
              ),
              CustomTextField(
                label: "Password",
                hint: "Enter Your Password",
                controller: password,
                isPassword: true,
                prefixIcon: Icons.password,
              ),

              CustomButtom(
                color: Colors.purple.shade900,
                onPressed: () async {
               controller.login(email.text, password.text,);
                },
                label: "Login",
              ),

              Text.rich(
                TextSpan(
                  text: "Don't Have An Account ? ",
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(SignUp());
                        },
                      style: TextStyle(
                        color: Colors.purple.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
