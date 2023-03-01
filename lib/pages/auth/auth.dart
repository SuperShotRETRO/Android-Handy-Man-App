import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:finalhandyman/pages/auth/phone_signup_login_page.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var verificationId = ''.obs;
  User? get currentUser => firebaseAuth.currentUser;
  var allUsers = UserDataController().AllUserDataList;
  Stream<User?> get authStateChange => firebaseAuth.authStateChanges();

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
    createUser(uid: currentUser?.uid, email: email,name: name);
  }

  Future<void>createUserWithPhone({
  required String phoneNo,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (_) {},
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
        });
    for(int i =0;i < allUsers.length;i++){
      if(allUsers[i].number == phoneNo){
        break;
      }
      else{}
      createUser(uid: currentUser?.uid,number: phoneNo);
    }
  }


  
  Future<bool> verifyOTP(String otp) async {
    var credential = await firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: otp));
    return credential.user != null ? true : false;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }


  Future createUser({ required String? uid , String? email,String? number, String? name }) async {
    final docUser = FirebaseFirestore.instance.collection('user').doc(uid);
    final json = {
      'email':email ?? "",
      'number': number ?? "",
      'name':name ?? "",
      'favourite':[]
    };
    await docUser.set(json);}

  }
