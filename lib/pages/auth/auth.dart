import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {

  UserDataController userDataController = Get.put(UserDataController());

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var verificationId = ''.obs;
  User? get currentUser => firebaseAuth.currentUser;
  Stream<User?> get authStateChange => firebaseAuth.authStateChanges();

  Future<UserCredential> googleSignIn () async {

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    createUser(uid: gUser.id,name: gUser.displayName,email: gUser.email);
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }



  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    createUser(uid: currentUser?.uid, email: email,name: name,);
  }


  Future<void>createUserWithPhone({
  required String phoneNo,
  }) async {

    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (_){},

        verificationFailed: (e){
          if (e.code == 'invalid-phone-number'){
            Get.snackbar('Error', 'Invalid Number');
          }
          else{
            Get.snackbar('Error', 'Other Error');
          }
        },
        codeSent: (String verificationId, int? resendToken){
          Get.offNamed(RouteHelper.getOTPPage(verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId){
          this.verificationId.value = verificationId;
        },
        timeout: Duration(seconds: 60));
  }


  
  Future<bool> verifyOTP(String otp) async {
    var credential = await firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: otp));
    print(currentUser?.uid);
    return credential.user != null ? true : false;

  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }


  Future createUser({ required String? uid , String? email,String? number, String? name }) async {
    final docUser = FirebaseFirestore.instance.collection('user').doc(uid);
    await FirebaseFirestore.instance.collection('user').doc(uid).collection('address').doc('0').set({'name':"",'addline1':'','addline2':"",'city':'','pin':""});
    final json = {
      'email':email ?? "",
      'number': number ?? "",
      'name':name ?? "",
      'favourite':[],
    };
    await docUser.set(json);}

  }
