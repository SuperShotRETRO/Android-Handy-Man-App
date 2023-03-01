import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/models/user_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/service_model.dart';
import '../pages/auth/auth.dart';

class UserDataController extends GetxController{
  var isLoading = true;
  var isCurrentLoading = true;
  var AllUserDataList = <UserDataModel>[];
  UserDataModel CurrentUserData = UserDataModel();

  Future<void> getData() async{
    try{
      QuerySnapshot alluserdatalist = await FirebaseFirestore.instance.collection('user').get();
      AllUserDataList.clear();
      for(var users in alluserdatalist.docs){
        AllUserDataList.add(UserDataModel(uid:users.id,email: users['email'],favourite: users['favourite']));
      }
      update();
      isLoading = false;
    }
    catch(e){
      Get.snackbar('Error', '${e.toString()}');
      print(e.toString());
    }
  }

  Future<void> getCurrentUserData() async{
    try{
      User? user = Auth().currentUser;
      var uid = user?.uid;
      var currentuserdata = await FirebaseFirestore.instance.collection('user').doc('${uid}').get();
      CurrentUserData = UserDataModel(uid: currentuserdata.id,name:currentuserdata['name'],email: currentuserdata['email'],favourite: currentuserdata['favourite']);
      update();
      isCurrentLoading = false;
    }
    catch(e){
      Get.snackbar('Error1', '${e.toString()}');
    }
  }

}