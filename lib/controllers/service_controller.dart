import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:finalhandyman/models/service_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/user_data_model.dart';
import '../utils/directions_repository.dart';

class ServiceController extends GetxController{
  var isLoading = true;
  var AllServiceList = <ServiceModel>[];
  var PopularServiceList = <ServiceModel>[];
  UserDataController userDataController = Get.put(UserDataController());

  Future<void> getData() async{
    try{
      QuerySnapshot recommendedservicelist = await FirebaseFirestore.instance.collection('popular_service').get();
      QuerySnapshot popularservicelist = await FirebaseFirestore.instance.collection('popular_service').orderBy('reviews',descending: true).limit(5).get();
      if(userDataController.lat ==0)
      {
        userDataController.getCurrentLocation();
      }
      AllServiceList.clear();
      PopularServiceList.clear();
      for(var service in recommendedservicelist.docs) {
        final directions =  await DirectionsRepository().getDirections("${userDataController.lat}, ${userDataController.long}", "${service['lat']}, ${service['long']}");
        AllServiceList.add(ServiceModel(name:service['name'], price:service['price'],rating: service['rating'],reviewCount: service['reviews'],category: service['category'],image:service['image'],id:service['id'],lat: service['lat'],long: service['long'],distance: directions['routes'][0]['legs'][0]['distance']['text'],duration: directions['routes'][0]['legs'][0]['duration']['text']));

      }
      for(var service in popularservicelist.docs) {
        final directions =  await DirectionsRepository().getDirections("${userDataController.lat}, ${userDataController.long}", "${service['lat']}, ${service['long']}");
        PopularServiceList.add(ServiceModel(name:service['name'], price:service['price'],rating: service['rating'],reviewCount: service['reviews'],category: service['category'],image:service['image'],id:service['id'],distance: directions['routes'][0]['legs'][0]['distance']['text'],duration: directions['routes'][0]['legs'][0]['duration']['text']));
      }
      update();
      isLoading = false;
    }
    catch(e){
      Get.snackbar('Error', '${e.toString()}');
    }
  }
}
