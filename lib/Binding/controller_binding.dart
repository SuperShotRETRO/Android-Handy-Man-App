import 'package:finalhandyman/controllers/category_details_controller.dart';
import 'package:finalhandyman/controllers/service_controller.dart';
import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings{
  @override
  void dependencies(){
    Get.put<ServiceController>(ServiceController());
    Get.put<CategoryServiceController>(CategoryServiceController());
    Get.put<UserDataController>(UserDataController());
  }
}