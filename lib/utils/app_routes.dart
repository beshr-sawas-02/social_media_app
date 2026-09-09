import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_media_app/view/auth/login_page.dart';
import 'package:social_media_app/view/auth/signup.dart';
import 'package:social_media_app/view/home/home_page.dart';


class AppRoutes {
  static final List<GetPage> namePages = [
    GetPage(
      name: RoutesPath.login,
      page: () => LoginPage(),
    ),
    GetPage(
     name: RoutesPath.home,
      page: () =>  HomePage(),
   ),
    GetPage(
     name: RoutesPath.signup,
      page: () =>  SignUp(),
   ),
  ];
}

class RoutesPath {
  static const home = '/home';
  static const login = '/login';
  static const signup = '/signup';
}

class RoutesWrapper {
  static get getInitialRoute {
    if (FirebaseAuth.instance.currentUser != null) {
      return RoutesPath.login;
    } else {
      return RoutesPath.login;
    }
  }
}