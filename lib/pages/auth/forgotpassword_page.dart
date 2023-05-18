import 'package:finalhandyman/utils/dimension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(Dimensions.width10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Email',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 80),
            ),
            Text('VERIFICATION'),
            SizedBox(
              height: 40,
            ),
            Text('Enter the verification code sent at support@admin.com'),
            SizedBox(
              height: Dimensions.height30,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(CupertinoIcons.person),
                labelText: 'E-Mail',
                hintText: 'E-Mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: Dimensions.height30,
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    auth.sendPasswordResetEmail(email: emailController.text);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black),
                  ),
                  child: Text('Verify')),
            ),
          ],
        ),
      ),
    );
  }
}
