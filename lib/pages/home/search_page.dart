import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/controllers/recommended_popular_service_controller.dart';
import 'package:finalhandyman/models/service_model.dart';
import 'package:finalhandyman/utils/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/route_helper.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_text_widget.dart';
import '../../widgets/small_text.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
  RecommendedPopularServiceController recommendedPopularServiceController =
      Get.put(RecommendedPopularServiceController());
}

class _SearchPageState extends State<SearchPage> {
  String name = '';
  @override
  Widget build(BuildContext context) {
    var allService = widget.recommendedPopularServiceController.AllServiceList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Get.offNamed(RouteHelper.getInitial());
          },
          icon: Icon(CupertinoIcons.arrow_left,color: Colors.black,),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search for a Service",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: Dimensions.height20,
            ),
            TextField(
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: "eg: Plumber",
                prefixIcon: Icon(Icons.search_rounded),
                prefixIconColor: Colors.black,
              ),
            ),
            SizedBox(
              height: Dimensions.height20,
            ),
            Expanded(
            child: ListView.builder(
                itemCount: allService.length,
                itemBuilder: (context, index) {
                  var data = allService[index];
                  if (name.isEmpty) {
                    return GestureDetector(
                      onTap: (){
                        Get.toNamed(RouteHelper.getserviceDetails(data.id));
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
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimensions.radius20),
                                  bottomLeft: Radius.circular(Dimensions.radius20),
                                ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(data.image))),
                            ),
                            //Text
                            Expanded(
                              child: Container(
                                height: Dimensions.listViewImgSize,
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
                                      BigText(text: data.name),
                                      SizedBox(height: Dimensions.height10,),
                                      SmallText(text: data.category),
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
                  }
                  if (data.name
                      .toString()
                      .toLowerCase()
                      .contains(name.toLowerCase())) {
                    return GestureDetector(
                      onTap: (){
                        Get.toNamed(RouteHelper.getserviceDetails(data.id));
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
                                      image: NetworkImage(data.image))),
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
                                      BigText(text: data.name),
                                      SizedBox(height: Dimensions.height10,),
                                      SmallText(text: data.category),
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
                  }
                  return Container();
                }))
          ],
        ),
      ),
    );
  }
}
