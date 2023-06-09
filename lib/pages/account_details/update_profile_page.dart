import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UpdateProfilePage extends StatelessWidget {
  UpdateProfilePage({Key? key}) : super(key: key);

  UserDataController userDataController = Get.put(UserDataController());



  @override
  Widget build(BuildContext context) {

    var name;
    var namecontroller = TextEditingController(text: userDataController.CurrentUserData.name);

    Future updateUser({required String uid}) async {
      final docUser = FirebaseFirestore.instance.collection('user').doc(uid);
      final json = {
        'name': name
      };
      await docUser.update(json);
    }


    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Update Profile",style: TextStyle(color: Colors.black),textAlign: TextAlign.center,)),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: (){
              Get.offNamed(RouteHelper.getInitial());
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
                    controller: namecontroller,
                    decoration: InputDecoration(
                      label: Text('Full Name'),
                      prefixIcon: Icon(CupertinoIcons.person)
                    ),
                    onChanged: (value){
                      name = value;
                    },
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        updateUser(uid: userDataController.CurrentUserData.uid,);
                        Get.offNamed(RouteHelper.getInitial());
                      },
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
