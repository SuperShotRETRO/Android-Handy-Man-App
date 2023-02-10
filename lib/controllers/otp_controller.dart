import 'package:finalhandyman/pages/home/home_page.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../pages/auth/auth.dart';

class OTPController extends GetxController{
  static OTPController get instance => Get.find();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void verifyOTP(String otp,String verificationID) async {
    final credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otp);
    try{
      await firebaseAuth.signInWithCredential(credential);
      Get.offNamed(RouteHelper.getLoginTree());
    }
    catch(e){
      print('error');
    }
  }
}

//var isVerified = await Auth().verifyOTP(otp);
//isVerified ? Get.offAll(HomePage()) : Get.back();