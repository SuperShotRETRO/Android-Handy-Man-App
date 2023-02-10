import 'package:finalhandyman/controllers/recommended_popular_service_controller.dart';
import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../routes/route_helper.dart';
import '../../utils/dimension.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_text_widget.dart';
import '../../widgets/small_text.dart';

class FavouritePage extends StatelessWidget {
  FavouritePage({Key? key}) : super(key: key);
  UserDataController userDataController = Get.put(UserDataController());
  RecommendedPopularServiceController recommendedPopularServiceController = Get.put(RecommendedPopularServiceController());

  @override
  Widget build(BuildContext context) {
    var currentuserdata = userDataController.CurrentUserData;
    var serviceList = recommendedPopularServiceController.AllServiceList;



    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(top: Dimensions.height45,bottom: Dimensions.height15),
              padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      BigText(text: "India"),
                      Row(
                        children: [
                          SmallText(text:"City"),
                          Icon(Icons.arrow_drop_down),
                        ],
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      width:  Dimensions.width45,
                      height: Dimensions.height45,
                      child: Icon(Icons.search,color: Colors.white,size: Dimensions.iconSize24,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius15),
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.height10,
          ),
          BigText(text: 'Favourite',),
          SizedBox(
            height: Dimensions.height10,
          ),
          currentuserdata.favourite.isEmpty ? BrokenHeart() : Expanded(
            child: SingleChildScrollView(
              child: GetBuilder<UserDataController>(
                  init: UserDataController(),
                  initState: (_){},
                  builder: (userDataController){
                    userDataController.getCurrentUserData();
                    recommendedPopularServiceController.getData();
                    return userDataController.isLoading ?CircularProgressIndicator(color: Colors.black,):ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: currentuserdata.favourite.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Get.toNamed(RouteHelper.getserviceDetails(
                                  recommendedPopularServiceController.AllServiceList[currentuserdata.favourite[index]].id));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.width20,
                                  right: Dimensions.width20,
                                  bottom: Dimensions.height10),
                              child: Row(
                                children: [
                                  //Image
                                  Container(
                                    width: Dimensions.listViewImgSize,
                                    height: Dimensions.listViewImgSize,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(Dimensions.radius20),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(serviceList[currentuserdata.favourite[index]].image))),
                                  ),
                                  //Text
                                  Expanded(
                                    child: Container(
                                      height: Dimensions.listViewTextContSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(Dimensions.radius20),
                                          bottomRight: Radius.circular(Dimensions.radius20),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: Dimensions.width10,right: Dimensions.width10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BigText(text: serviceList[currentuserdata.favourite[index]].name),
                                            SizedBox(height: Dimensions.height10,),
                                            SmallText(text: serviceList[currentuserdata.favourite[index]].category),
                                            SizedBox(height: Dimensions.height10,),
                                            Row(
                                              children: [
                                                IconText(
                                                    icon: Icons.location_on,
                                                    text: "1.5km",
                                                    iconColor: Colors.black),
                                                SizedBox(
                                                  width: Dimensions.width30,
                                                ),
                                                IconText(
                                                    icon: Icons.access_time,
                                                    text: "30min",
                                                    iconColor: Colors.black)
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }

              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BrokenHeart extends StatelessWidget {
  const BrokenHeart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(
              angle: 0,
              child: Icon(Icons.heart_broken,size: 54,color: Colors.grey,),
          ),
          SizedBox(height: Dimensions.height10,),
          Text("You don't like anyone, \nThat's Sad",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w200),)
        ],
      ),
    );
  }
}

