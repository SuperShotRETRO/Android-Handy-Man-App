import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/controllers/category_details_controller.dart';
import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:finalhandyman/pages/home/main_page.dart';
import 'package:finalhandyman/utils/dimension.dart';
import 'package:finalhandyman/widgets/app_column.dart';
import 'package:finalhandyman/widgets/app_icon.dart';
import 'package:finalhandyman/widgets/big_text.dart';
import 'package:finalhandyman/widgets/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/recommended_popular_service_controller.dart';



class ServiceDetails extends StatelessWidget {
  int id;
  ServiceDetails({Key? key,required this.id}) : super(key: key);
  RecommendedPopularServiceController recommendedPopularServiceController = Get.put(RecommendedPopularServiceController());
  UserDataController userDataController = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    var service = recommendedPopularServiceController.AllServiceList[id-1];
    userDataController.getCurrentUserData();
    bool isPresent = false;

    Future addFav({required String uid,required int id}) async {
      final docUser = FirebaseFirestore.instance.collection('user').doc(uid);
      final json = {
        'favourite':[...userDataController.CurrentUserData.favourite,id],
      };
      await docUser.update(json);

    }

    //Fav Checker
    for(var i = 0;i<userDataController.CurrentUserData.favourite.length;i++){
      if(id == userDataController.CurrentUserData.favourite[i]){
        isPresent = true;
        break;
      }
      else{
        isPresent = false;
      }
    }



    return GetBuilder<UserDataController>(
      init: UserDataController(),
      initState: (_){},
      builder: (userDataController){
        userDataController.getCurrentUserData();

        return Scaffold(
          backgroundColor: Colors.white,
          body: userDataController.isLoading || recommendedPopularServiceController.AllServiceList.isEmpty? Center(child: CircularProgressIndicator(color: Colors.black,)):Stack(
            children: [
              //image
              Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.maxFinite,
                    height: Dimensions.popularServiceImgSize,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(service.image))),
                  )),
              //icons
              Positioned(
                  top: Dimensions.height45,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: AppIcon(icon: Icons.arrow_back)),
                    ],
                  )),
              //intro head
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: Dimensions.popularServiceImgSize - 20,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        top: Dimensions.height20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Dimensions.radius20),
                        topLeft: Radius.circular(Dimensions.radius20),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppColumn(
                          price: service.price,
                          rating: service.rating,
                          reviewCount: service.reviewCount,
                          text: service.name,
                          category: service.category,
                        ),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        BigText(text: "Introduction"),
                        SizedBox(height: Dimensions.height20,),
                        Expanded(
                            child:SingleChildScrollView(
                              child: ExpandableText(
                                  text:
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sollicitudin, nibh at congue tincidunt, arcu magna fringilla velit, a sollicitudin mauris nulla ornare sem. Donec a pharetra nisi. Integer pulvinar purus ligula, non cursus quam lobortis ut. Fusce molestie, velit in pulvinar lacinia, risus massa efficitur est, sed sollicitudin metus odio quis enim. Nam eros nisl, varius et risus id, sodales rhoncus leo. Morbi tristique eu arcu in scelerisque. Donec blandit faucibus velit. Quisque accumsan sapien eu dictum sollicitudin."),
                            )
                        )
                      ],
                    ),
                  )),
            ],
          ),
          bottomNavigationBar: Container(
            height: Dimensions.bottomHeightBar,
            padding: EdgeInsets.only(
                top: Dimensions.height30,
                bottom: Dimensions.height30,
                left: Dimensions.width20,
                right: Dimensions.width20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius20 * 2),
                topRight: Radius.circular(Dimensions.radius20 * 2),
              ),
              color: Colors.white24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.only(
                        top: Dimensions.height20,
                        bottom: Dimensions.height20,
                        left: Dimensions.width20,
                        right: Dimensions.width20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white),
                    child: IconButton(
                      onPressed: isPresent ?
                      (){}
                      :() => addFav(uid: userDataController.CurrentUserData.uid, id: id),
                      icon: Icon(isPresent ? Icons.favorite : Icons.favorite_border),//NEEDS CHANGE
                    )
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: Dimensions.height20,
                      bottom: Dimensions.height20,
                      left: Dimensions.width20,
                      right: Dimensions.width20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.black),
                  child: BigText(
                    text: "Book Now",
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );


  }
}