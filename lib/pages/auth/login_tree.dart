import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:finalhandyman/pages/auth/auth.dart';
import 'package:finalhandyman/pages/auth/login_screen.dart';
import 'package:finalhandyman/pages/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/service_controller.dart';

class LoginTree extends StatefulWidget {
  LoginTree({Key? key}) : super(key: key);

  @override
  State<LoginTree> createState() => _LoginTreeState();
}

class _LoginTreeState extends State<LoginTree> {
  UserDataController userDataController = Get.put(UserDataController());
  ServiceController serviceController =
      Get.put(ServiceController());


  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: Auth().authStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const LoginScreen();
          }
        });
  }
}
