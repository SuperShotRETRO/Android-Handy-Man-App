import 'package:finalhandyman/pages/account_details/update_profile_page.dart';
import 'package:finalhandyman/pages/auth/login_screen.dart';
import 'package:finalhandyman/pages/auth/login_tree.dart';
import 'package:finalhandyman/pages/auth/phone_signup_login_page.dart';
import 'package:finalhandyman/pages/auth/signup_screen.dart';
import 'package:finalhandyman/pages/auth/otp_page.dart';
import 'package:finalhandyman/pages/home/home_page.dart';
import 'package:finalhandyman/pages/service/service_detail.dart';
import 'package:finalhandyman/pages/splash/splash_page.dart';
import 'package:get/get.dart';

import '../pages/categorypage/category_page.dart';

class RouteHelper{
  static const String splashPage = "/splash-page";
  static const String loginTree = "/login-page";
  static const String loginPage = "/login-page";
  static const String signupPage = "/signup-page";
  static const String phoneSignupPage = "/phone-signup-page";
  static const String otpPage = "/OTP-page";
  static const String initial = "/";
  static const String serviceDetails = "/popular-service";
  static const String categoryPage = "/category-list";
  static const String updateProfilePage = "/update-Profile-Page";


  static String getSplash()=>'$splashPage';
  static String getLoginTree()=> '$loginTree';
  static String getLoginPage()=> '$loginPage';
  static String getSignupPage()=> '$signupPage';
  static String getPhoneSignupPage()=> '$phoneSignupPage';
  static String getOTPPage(String verificationID)=> '$otpPage?verificationID=$verificationID';
  static String getInitial()=> '$initial';
  static String getserviceDetails(int id)=> '$serviceDetails?pageId=$id';
  static String getCategoryPage(String category)=> '$categoryPage?category=$category';
  static String getUpdateProfilePage() => '$updateProfilePage';


  static List<GetPage> routes = [
    GetPage(name: splashPage, page: ()=>SplashScreen()),
    GetPage(name: loginTree, page: ()=>LoginTree()),
    GetPage(name: loginPage, page: ()=>LoginScreen()),
    GetPage(name: signupPage, page: ()=>SignupPage()),
    GetPage(name: phoneSignupPage, page: ()=>PhoneSignupLoginPage()),
    GetPage(name: otpPage, page: (){
      var verificationID = Get.parameters['verificationID'];
      return OTPPage(verificationID: verificationID!);
    }),
    GetPage(name: initial , page: ()=>HomePage()),
    GetPage(name: serviceDetails, page: (){
      var id = Get.parameters['pageId'];
      return ServiceDetails(id:int.parse(id!));
    },
        transition: Transition.fadeIn
    ),
    GetPage(name: categoryPage, page: (){
      var category = Get.parameters['category'];
      return CategoryPage(category: category!,);
    },
    transition: Transition.fadeIn
    ),
    GetPage(name: updateProfilePage, page: ()=>UpdateProfilePage()),
  ];
}