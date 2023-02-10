import 'package:finalhandyman/controllers/category_details_controller.dart';
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

class CategoryPage extends StatelessWidget {
  String category;
  CategoryPage({Key? key,required this.category}) : super(key: key);
  CategoryServiceController categoryServiceController = Get.put(CategoryServiceController());

  @override
  Widget build(BuildContext context) {

    var categoryList;
    switch(category){
      case 'Electrian':{
        categoryList = categoryServiceController.ElectrianServiceList;
        break;
      }
      case 'Barber':{
        categoryList = categoryServiceController.BarberServiceList;
        break;
      }
      case 'Plumber':{
        categoryList = categoryServiceController.PlumberServiceList;
        break;
      }
    }

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
          BigText(text: category),
          SizedBox(
            height: Dimensions.height10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: GetBuilder<CategoryServiceController>(
                  init: CategoryServiceController(),
                  initState: (_){},
                  builder: (categoryServiceController){
                    categoryServiceController.getElectrianData();
                    categoryServiceController.getBarberData();
                    categoryServiceController.getPlumberData();
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categoryList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Get.toNamed(RouteHelper.getserviceDetails(categoryList[index].id));
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
                                            image: NetworkImage(categoryList[index].image))),
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
                                            BigText(text: categoryList[index].name),
                                            SizedBox(height: Dimensions.height10,),
                                            SmallText(text: categoryList[index].category),
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
