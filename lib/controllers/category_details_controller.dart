import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/models/service_model.dart';
import 'package:get/get.dart';

class CategoryServiceController extends GetxController {
  var isLoading = true;
  var ElectrianServiceList = <ServiceModel>[];
  var BarberServiceList = <ServiceModel>[];
  var PlumberServiceList = <ServiceModel>[];

  Future<void> getElectrianData() async {
    try {
      QuerySnapshot electrianservicelist = await FirebaseFirestore.instance
          .collection('popular_service')
          .where('category', isEqualTo: 'Electrian')
          .get();
      ElectrianServiceList.clear();
       for (var service in electrianservicelist.docs) {
          ElectrianServiceList.add(ServiceModel(
            name: service['name'],
            price: service['price'],
            rating: service['rating'],
            reviewCount: service['reviews'],
            category: service['category'],
            image: service['image'],
            id: service['id'],
        ));
      }
      update();
      isLoading = false;
    } catch (e) {
      Get.snackbar('Error', '${e.toString()}');
    }
  }

  Future<void> getBarberData() async {
    try {
      QuerySnapshot barberservicelist = await FirebaseFirestore.instance
          .collection('popular_service')
          .where('category', isEqualTo: 'Barber')
          .get();
      BarberServiceList.clear();
      for (var service in barberservicelist.docs) {
        BarberServiceList.add(ServiceModel(
          name: service['name'],
          price: service['price'],
          rating: service['rating'],
          reviewCount: service['reviews'],
          category: service['category'],
          image: service['image'],
          id: service['id'],
        ));
      }
      update();
      isLoading = false;
    } catch (e) {
      Get.snackbar('Error', '${e.toString()}');
    }
  }

  Future<void> getPlumberData() async {
    try {
      QuerySnapshot plumberservicelist = await FirebaseFirestore.instance
          .collection('popular_service')
          .where('category', isEqualTo: 'Plumber')
          .get();
      PlumberServiceList.clear();
      for (var service in plumberservicelist.docs) {
        PlumberServiceList.add(ServiceModel(
          name: service['name'],
          price: service['price'],
          rating: service['rating'],
          reviewCount: service['reviews'],
          category: service['category'],
          image: service['image'],
          id: service['id'],
        ));
      }
      update();
      isLoading = false;
    } catch (e) {
      Get.snackbar('Error', '${e.toString()}');
    }
  }
}
