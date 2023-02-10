import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/models/service_model.dart';
import 'package:get/get.dart';

class RecommendedPopularServiceController extends GetxController{
  var isLoading = true;
  var AllServiceList = <ServiceModel>[];
  var PopularServiceList = <ServiceModel>[];

  Future<void> getData() async{
    try{
      QuerySnapshot recommendedservicelist = await FirebaseFirestore.instance.collection('popular_service').get();
      QuerySnapshot popularservicelist = await FirebaseFirestore.instance.collection('popular_service').orderBy('reviews',descending: true).limit(5).get();
      AllServiceList.clear();
      PopularServiceList.clear();
      for(var service in recommendedservicelist.docs) {
        AllServiceList.add(ServiceModel(name:service['name'], price:service['price'],rating: service['rating'],reviewCount: service['reviews'],category: service['category'],image:service['image'],id:service['id'],));

      }
      for(var service in popularservicelist.docs) {
        PopularServiceList.add(ServiceModel(name:service['name'], price:service['price'],rating: service['rating'],reviewCount: service['reviews'],category: service['category'],image:service['image'],id:service['id'],));
      }
      update();
      isLoading = false;
    }
    catch(e){
      Get.snackbar('Error', '${e.toString()}');
    }
  }
}
