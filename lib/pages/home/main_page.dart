import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:finalhandyman/pages/home/main_page_body.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:finalhandyman/utils/dimension.dart';
import 'package:finalhandyman/widgets/big_text.dart';
import 'package:finalhandyman/widgets/small_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  UserDataController userDataController = Get.put(UserDataController());

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => firebaseAuth.currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDataController>(
        init: UserDataController(),
        initState: (_) {},
        builder: (userDataController) {
          bool isPresent = false;
          if(userDataController.AllUserDataList.isEmpty){
            userDataController.getData();
          }
          var allUsers = userDataController.AllUserDataList;
          if (userDataController.place.isEmpty) {
            userDataController.getCurrentLocation();
          }
          for (int i = 0; i < allUsers.length; i++) {
            if (currentUser?.uid == allUsers[i].uid) {
              isPresent = true;
              break;
            }
            else{
              isPresent = false;
            }
          }
          //if(!isPresent){
            //createUser(
                //uid: currentUser?.uid,email: currentUser?.email, number: currentUser?.phoneNumber,name: currentUser?."Guest_${currentUser?.uid}");
          //}

          return userDataController.place.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.black,
                ))
              : Scaffold(
                  body: Column(
                    children: [
                      Container(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: Dimensions.height45,
                              bottom: Dimensions.height15),
                          padding: EdgeInsets.only(
                              left: Dimensions.width20,
                              right: Dimensions.width20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  BigText(text: "India"),
                                  SmallText(
                                      text:
                                          '${userDataController.place[0].subLocality}'),
                                ],
                              ),
                              Center(
                                child: Container(
                                  width: Dimensions.width45,
                                  height: Dimensions.height45,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: Dimensions.iconSize24,
                                    ),
                                    onPressed: () {
                                      Get.offNamed(RouteHelper.getSearchPage());
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius15),
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: MainPageBody(),
                      )),
                    ],
                  ),
                );
        });
  }

  Future createUser(
      {required String? uid,
      String? email,
      String? number,
      String? name}) async {
    final docUser = FirebaseFirestore.instance.collection('user').doc(uid);
    final json = {
      'email': email ?? "",
      'number': number ?? "",
      'name': name ?? "",
      'favourite': []
    };
    await docUser.set(json);
  }
}
