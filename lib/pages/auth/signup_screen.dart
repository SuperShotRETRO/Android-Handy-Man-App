import 'package:finalhandyman/routes/route_helper.dart';
import 'package:finalhandyman/utils/dimension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/user_data_controller.dart';
import 'auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();

}

class _SignupPageState extends State<SignupPage> {

  bool passwordVisible = true;

  UserDataController userDataController = Get.put(UserDataController());

  String? errorMessage = '';
  bool isLogin = true;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text,name: nameController.text);
      Get.offNamed(RouteHelper.loginTree);
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
              Text("Hello there",style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),),

              Form(
                  child: Container(
                    padding: EdgeInsets.only(top: 20,bottom: 20,right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Name
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.padlock),
                              labelText: 'Name',
                              hintText: 'Name',
                              border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: Dimensions.height15,),

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

                        //Signup Button
                        SizedBox(
                          width: double.infinity,
                          height: Dimensions.height45,
                          child: ElevatedButton(
                            onPressed: ()=>{
                                createUserWithEmailAndPassword(),
                            },
                            child: Text('Sign Up'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.black),
                            ) ,
                          ),
                        ),

                        //Sign-In with Google
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: Dimensions.height15,),
                            Text('OR'),
                            SizedBox(height: Dimensions.height15,),
                            //Google
                            SizedBox(
                              height: Dimensions.height45,
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                  onPressed: (){},
                                  icon: Image(image: AssetImage("TestImages/GoogleLogo.jpg"),width:20,),
                                  label: Text("Sign In With Google")),
                            ),
                            SizedBox(height: Dimensions.height15,),

                            //Phone
                            SizedBox(
                              height: Dimensions.height45,
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                  onPressed: (){},
                                  icon: Image(image: AssetImage("TestImages/GoogleLogo.jpg"),width:20,),
                                  label: Text("Sign In With Google")),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height15,),

                        //Already have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an Account'),
                            TextButton(
                                onPressed:() {
                                  Get.offNamed(RouteHelper.getLoginPage());
                                },
                                child: Text('Log In'))
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

