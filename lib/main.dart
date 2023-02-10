import 'package:finalhandyman/Binding/controller_binding.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        initialBinding: ControllerBinding(),
        initialRoute: RouteHelper.getSplash(),
        getPages: RouteHelper.routes,
    );
  }
}


