import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/otp_controller.dart';
import '../../utils/dimension.dart';
import 'auth.dart';

class PhoneSignupLoginPage extends StatefulWidget {
  PhoneSignupLoginPage({Key? key}) : super(key: key);

  @override
  State<PhoneSignupLoginPage> createState() => _PhoneSignupLoginPageState();
  final FirebaseAuth _auth = FirebaseAuth.instance;

}

class _PhoneSignupLoginPageState extends State<PhoneSignupLoginPage> {

  OTPController otpController = Get.put(OTPController());
  var phoneNoController = TextEditingController();


  Future<void> createUserWithPhoneAndPassword() async {
    try{
      await Auth().createUserWithPhone(phoneNo: "+91${phoneNoController.text}");

    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: Dimensions.width30,right:Dimensions.width30,top: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ring Ring, Ring Ring",style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),),

              Form(
                  child: Container(
                    padding: EdgeInsets.only(top: 40,bottom: 20,right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //E-Mail
                        TextFormField(
                          controller: phoneNoController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.person),
                            labelText: 'Phone No.',
                            hintText: 'Phone No.',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: Dimensions.height15,),

                        //Login Button
                        SizedBox(
                          width: double.infinity,
                          height: Dimensions.height45,
                          child: ElevatedButton(
                            onPressed: ()async{
                              createUserWithPhoneAndPassword();
                            },
                            child: Text('Login'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.black),
                            ) ,
                          ),
                        ),

                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

