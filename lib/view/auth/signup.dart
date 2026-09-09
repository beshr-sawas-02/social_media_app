import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controller/auth_controller.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  AuthController Controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<AuthController>(
        builder: (controller) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                      left: 15.0,
                      bottom: 8.0,
                    )),
                    Text(
                      "Sign Up Now To Our Social Media",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                      left: 15.0,
                      bottom: 8.0,
                    )),
                    Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.purple.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, bottom: 8.0, right: 15.0),
                  child: TextField(
                    controller: Controller.userName,
                    decoration: InputDecoration(
                        labelText: 'UserName',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.purple.shade900,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, bottom: 8.0, right: 15.0),
                  child: TextField(
                    controller: Controller.email,
                    decoration: InputDecoration(
                        labelText: 'Please Enter Your Email Address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.purple.shade900,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, bottom: 8.0, right: 15.0),
                  child: TextField(
                    controller: Controller.password,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: 'Please Enter Your Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.purple.shade900,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.visibility,
                          color: Colors.purple.shade900,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, bottom: 8.0, right: 15.0),
                  child: TextField(
                    controller: Controller.phone,
                    decoration: InputDecoration(
                        labelText: 'phone Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.purple.shade900,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, right: 15.0, left: 15.0),
                  child: SizedBox(
                    height: 50,
                    child: Card(
                      color: Colors.purple.shade900,
                      child: InkWell(
                        onTap: () async {
                          await controller.signup();
                        },
                        child: const Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
