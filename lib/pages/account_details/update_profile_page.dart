import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Update Profile",style: TextStyle(color: Colors.black),textAlign: TextAlign.center,)),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: (){
              Get.back();
              },
            icon: Icon(CupertinoIcons.back,color: Colors.black,)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(100),
          child: Column(
            children: [
              Stack(
                  children:[
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(image: AssetImage('TestImages/1 (1).jpeg'),fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.black
                        ),
                        child: Icon(
                          CupertinoIcons.camera,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  ]
              ),
              SizedBox(height: 50,),
              Form(child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Full Name'),
                      prefixIcon: Icon(CupertinoIcons.person)
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecoration(
                        label: Text('Email'),
                        prefixIcon: Icon(Icons.email_outlined)
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecoration(
                        label: Text('Phone No.'),
                        prefixIcon: Icon(CupertinoIcons.phone)
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecoration(
                        label: Text('Password'),
                        prefixIcon: Icon(CupertinoIcons.person)
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Text("Submit"),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
