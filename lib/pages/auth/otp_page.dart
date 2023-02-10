import 'package:finalhandyman/controllers/otp_controller.dart';
import 'package:finalhandyman/utils/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OTPPage extends StatefulWidget {
  final String verificationID;
  OTPPage({Key? key, required this.verificationID}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  OTPController otpController = Get.put(OTPController());

  @override
  Widget build(BuildContext context) {
    var otp;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(Dimensions.width10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CODE',
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
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              onSubmit: (code) {
                otp = code;
                otpController.verifyOTP(otp,widget.verificationID);
              },
            ),
            SizedBox(
              height: Dimensions.height30,
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    otpController.verifyOTP(otp,widget.verificationID);
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
