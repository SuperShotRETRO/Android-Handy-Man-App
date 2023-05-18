import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/models/address_model.dart';
import 'package:finalhandyman/models/orders_model.dart';
import 'package:finalhandyman/models/user_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../pages/auth/auth.dart';

class UserDataController extends GetxController{
  var isLoading = true;
  var isCurrentLoading = true;
  var AllUserDataList = <UserDataModel>[];
  UserDataModel CurrentUserData = UserDataModel();
  var AddressDataList = <AddressModel>[];
  var OrdersList = <OrdersModel>[];
  var lat = 0.0;
  var long = 0.0;
  List<Placemark> place = [];

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
      CurrentUserData = UserDataModel(uid: currentuserdata.id,name:currentuserdata['name'],email: currentuserdata['email'],favourite: currentuserdata['favourite'],number: currentuserdata['number']);
      update();
      isCurrentLoading = false;
    }
    catch(e){
      User? user = Auth().currentUser;
      Auth().createUser(uid: user?.uid,number: user?.phoneNumber,name:"Guest_${user?.uid}" );
    }
  }
  
  Future<void> getAddress() async{
    try{
      User? user = Auth().currentUser;
      var uid = user?.uid;
      QuerySnapshot alladdresslist = await FirebaseFirestore.instance.collection('user').doc('${uid}').collection('address').get();
      AddressDataList.clear();
      for(var address in alladdresslist.docs){
        AddressDataList.add(AddressModel(name: address['name'], addressline1: address['addline1'],addressline2: address['addline2'],city: address['city'],pin: address['pin'],));
      }
      update();
      isLoading = false;
    }
    catch(e){
      Get.snackbar('Error2', '${e.toString()}');
    }
  }

  Future<void> getCurrentLocation() async {
    try{
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error("Service Disabled");
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error("Permission denied");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Plzz Enable Permission');
      }

      Geolocator.getCurrentPosition().then((value) {
        lat = value.latitude;
        long = value.longitude;
      });
      if ( lat != 0) {
        place = await placemarkFromCoordinates(lat, long);
      }
      update();
      isLoading = false;

    }
    catch(e){
      Get.snackbar('e', '${e.toString()}');
    }
  }

  Future<void> getOrderInfo() async {
    try{
      User? user = Auth().currentUser;
      var uid = user?.uid;
      QuerySnapshot orderinfo = await FirebaseFirestore.instance.collection('user').doc('${uid}').collection('orders').get();
      OrdersList.clear();
      for(var orders in orderinfo.docs){
        OrdersList.add(OrdersModel(name: orders['name'], orderId: orders['order id'],price: orders['price'],datetime: orders['time'],status: orders['status'],));
      }
      update();
      isLoading = false;
    }
    catch(e){
      Get.snackbar('e', '${e.toString()}');
    }
  }

}