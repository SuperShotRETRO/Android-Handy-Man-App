import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:finalhandyman/utils/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../auth/auth.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  UserDataController userDataController = Get.put(UserDataController());

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {

    var currentUser = userDataController.CurrentUserData;
    print(currentUser.name);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Profile",style: TextStyle(color: Colors.black),)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<UserDataController>(
          initState: (_){},
          init: UserDataController(),
          builder: (userDataController){
            userDataController.getCurrentUserData();
            return userDataController.isLoading ? CircularProgressIndicator(color: Colors.black,):Container(
              color: Colors.white,
              padding: EdgeInsets.all(Dimensions.width10),
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
                              CupertinoIcons.pen,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      ]
                  ),
                  SizedBox(height: 10,),
                  Text(currentUser.name,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black),),
                  Text(currentUser.email,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                  SizedBox(height: 20,),
                  SizedBox(width: 150,
                    child: ElevatedButton(
                      onPressed: (){
                        Get.offNamed(RouteHelper.getUpdateProfilePage());
                      },
                      child: Text("Edit Profile"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          side: BorderSide.none,
                          shape: StadiumBorder()
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height30,),
                  Divider(),
                  SizedBox(height: Dimensions.height10,),

                  //Settings
                  ListTile(
                    leading: Container(
                      width: Dimensions.width30,
                      height: Dimensions.height30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue.withOpacity(0.1)
                      ),
                      child: Icon(Icons.settings,color: Colors.blueAccent),
                    ),
                    title: Text("Settings"),
                    trailing: Container(
                      width: Dimensions.width30,
                      height: Dimensions.height30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black.withOpacity(0.1)
                      ),
                      child: Icon(CupertinoIcons.arrowtriangle_right,size: Dimensions.iconSize16,color: Colors.grey,),
                    ),
                  ),

                  //Logout
                  GestureDetector(
                    onTap: signOut,
                    child: ListTile(
                      leading: Container(
                        width: Dimensions.width30,
                        height: Dimensions.height30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.red.withOpacity(0.1)
                        ),
                        child: Icon(Icons.logout_outlined,color: Colors.red,),
                      ),
                      title: Text("Logout"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
