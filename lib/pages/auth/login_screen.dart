import 'package:finalhandyman/utils/dimension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/user_data_controller.dart';
import '../../routes/route_helper.dart';
import 'auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  bool passwordVisible = true;

  UserDataController userDataController = Get.put(UserDataController());

  String? errorMessage = '';
  bool isLogin = true;


  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try{
      await Auth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    }
    on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
      });
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
              Text("Welcome Back",style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),),

              Form(
                  child: Container(
                    padding: EdgeInsets.only(top: 20,bottom: 20,right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //E-Mail
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.person),
                            labelText: 'E-Mail',
                            hintText: 'E-Mail',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: Dimensions.height15,),

                        //Password
                        TextFormField(
                          controller: passwordController,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.padlock),
                            labelText: 'Password',
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(Icons.remove_red_eye_sharp),
                            )
                          ),
                        ),
                        SizedBox(height: Dimensions.height15,),

                        //Forget Password
                        TextButton(
                            onPressed: (){},
                            child: Text("Forgot Password?")),
                        SizedBox(height: Dimensions.height15+5,),

                        //Login Button
                        SizedBox(
                          width: double.infinity,
                          height: Dimensions.height45,
                          child: ElevatedButton(
                              onPressed: signInWithEmailAndPassword,
                              child: Text('Login'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.black),
                              ) ,
                          ),
                        ),

                        //Sign-In with Google
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: Dimensions.height20,),
                            Text('OR'),
                            SizedBox(height: Dimensions.height20,),
                            SizedBox(
                              height: Dimensions.height45,
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                  onPressed: (){},
                                  icon: Image(image: AssetImage("TestImages/GoogleLogo.jpg"),width:20,),
                                  label: Text("Sign In With Google")),
                            )
                          ],
                        ),
                        SizedBox(height: Dimensions.height15,),

                        //Phone
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Dimensions.height45,
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                  onPressed: (){
                                    Get.offNamed(RouteHelper.phoneSignupPage);
                                  },
                                  icon: Icon(CupertinoIcons.phone,color: Colors.black,),
                                  label: Text("Sign In With Phone")),
                            )
                          ],
                        ),
                        SizedBox(height: Dimensions.height30,),

                        //Create Account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an Account"),
                            TextButton(
                                onPressed:() {
                                  Get.offNamed(RouteHelper.getSignupPage());
                                },
                                child: Text('Sign Up'))
                          ],
                        )
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

