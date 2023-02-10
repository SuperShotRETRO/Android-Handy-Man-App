import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:finalhandyman/pages/auth/auth.dart';
import 'package:finalhandyman/pages/auth/login_screen.dart';
import 'package:finalhandyman/pages/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/recommended_popular_service_controller.dart';

class LoginTree extends StatefulWidget {
  LoginTree({Key? key}) : super(key: key);

  @override
  State<LoginTree> createState() => _LoginTreeState();
}

class _LoginTreeState extends State<LoginTree> {
  UserDataController userDataController = Get.put(UserDataController());
  RecommendedPopularServiceController recommendedPopularServiceController =
      Get.put(RecommendedPopularServiceController());


  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: Auth().authStateChange,
        builder: (context, snapshot) {
          userDataController.getData();
          recommendedPopularServiceController.getData();
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const LoginScreen();
          }
        });
  }
}
