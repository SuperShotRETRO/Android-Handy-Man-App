import 'package:finalhandyman/pages/account_details/orders_page.dart';
import 'package:finalhandyman/pages/account_details/profile_screen.dart';
import 'package:finalhandyman/pages/account_details/update_profile_page.dart';
import 'package:finalhandyman/pages/address/address_book.dart';
import 'package:finalhandyman/pages/address/map_screen.dart';
import 'package:finalhandyman/pages/auth/forgotpassword_page.dart';
import 'package:finalhandyman/pages/auth/login_screen.dart';
import 'package:finalhandyman/pages/auth/login_tree.dart';
import 'package:finalhandyman/pages/auth/phone_signup_login_page.dart';
import 'package:finalhandyman/pages/auth/signup_screen.dart';
import 'package:finalhandyman/pages/auth/otp_page.dart';
import 'package:finalhandyman/pages/checkout/checkout_page.dart';
import 'package:finalhandyman/pages/home/home_page.dart';
import 'package:finalhandyman/pages/home/search_page.dart';
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
  static const String forgotPage = "/forgot-page";
  static const String initial = "/";
  static const String searchPage = "/search-page";
  static const String serviceDetails = "/service-Details";
  static const String checkoutPage = "/checkout-Page";
  static const String categoryPage = "/category-list";
  static const String profilePage = "/profile-page";
  static const String updateProfilePage = "/update-Profile-Page";
  static const String addressBookPage = "/address-Page";
  static const String ordersPage = "/orders-page";
  static const String mapScreen = "/map-screen";


  static String getSplash()=>'$splashPage';
  static String getLoginTree()=> '$loginTree';
  static String getLoginPage()=> '$loginPage';
  static String getSignupPage()=> '$signupPage';
  static String getPhoneSignupPage()=> '$phoneSignupPage';
  static String getOTPPage(String verificationID)=> '$otpPage?verificationID=$verificationID';
  static String getForgotPage()=> '$forgotPage';
  static String getInitial()=> '$initial';
  static String getSearchPage()=>'$searchPage';
  static String getserviceDetails(int id)=> '$serviceDetails?pageId=$id';
  static String getCheckoutPage(int id)=> '$checkoutPage?pageId=$id';
  static String getCategoryPage(String category)=> '$categoryPage?category=$category';
  static String getProfilePage()=> '$profilePage';
  static String getUpdateProfilePage() => '$updateProfilePage';
  static String getAddressPage() => '$addressBookPage';
  static String getOrdersPage() => '$ordersPage';
  static String getMapScreen() => '$mapScreen';


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
    GetPage(name: forgotPage, page: ()=>ForgotPasswordPage()),
    GetPage(name: initial , page: ()=>HomePage()),
    GetPage(name: searchPage, page: ()=>SearchPage()),
    GetPage(name: serviceDetails, page: (){
      var id = Get.parameters['pageId'];
      return ServiceDetails(id:int.parse(id!));
    },
        transition: Transition.fadeIn
    ),
    GetPage(name: checkoutPage, page: (){
      var id = Get.parameters['pageId'];
      return CheckoutPage(id: int.parse(id!),);
    }),
    GetPage(name: categoryPage, page: (){
      var category = Get.parameters['category'];
      return CategoryPage(category: category!,);
    },
    transition: Transition.fadeIn
    ),
    GetPage(name: profilePage, page: ()=>ProfileScreen()),
    GetPage(name: updateProfilePage, page: ()=>UpdateProfilePage()),
    GetPage(name: addressBookPage, page: ()=>AddressBook()),
    GetPage(name: ordersPage, page: ()=>OrdersPage()),
    GetPage(name: mapScreen, page: ()=>MapScreen()),
  ];
}