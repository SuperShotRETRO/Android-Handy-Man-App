import 'package:dots_indicator/dots_indicator.dart';
import 'package:finalhandyman/controllers/category_details_controller.dart';
import '../../controllers/service_controller.dart';
import 'package:finalhandyman/models/service_model.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:finalhandyman/utils/dimension.dart';
import 'package:finalhandyman/widgets/app_column.dart';
import 'package:finalhandyman/widgets/big_text.dart';
import 'package:finalhandyman/widgets/category_list.dart';
import 'package:finalhandyman/widgets/icon_text_widget.dart';
import 'package:finalhandyman/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';


class MainPageBody extends StatefulWidget {
  MainPageBody({Key? key}) : super(key: key);
  ServiceController serviceController =
  Get.put(ServiceController());
  CategoryServiceController categoryServiceController =
  Get.put(CategoryServiceController());


  @override
  State<MainPageBody> createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
        init: ServiceController(),
        initState: (_) {},
        builder: (serviceController) {
          if(serviceController.PopularServiceList.isEmpty && serviceController.AllServiceList.isEmpty) {
            serviceController.getData();
          }
          return serviceController.PopularServiceList.isEmpty ? CircularProgressIndicator(color: Colors.black,):Column(children: [
            //Image Carousel
            Container(
              height: Dimensions.pageView,
              child:PageView.builder(
                  controller: pageController,
                  itemCount: serviceController.PopularServiceList.length,
                  itemBuilder: (BuildContext context, position) {
                    return _buildPageItem(
                        position,
                        serviceController
                            .PopularServiceList[position]);
                  }),
            ),
            //Dots Indicator
            DotsIndicator(
              dotsCount: serviceController.PopularServiceList.isEmpty?1:serviceController.PopularServiceList.length,
              position: _currPageValue,
              decorator: DotsDecorator(
                activeColor: Colors.black,
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),

            SizedBox(
              height: Dimensions.height30,
            ),

            //Category
            Container(
              margin: EdgeInsets.only(left: Dimensions.width30),
              child: BigText(text: "Category"),
            ),
            CategoryList(),

            //Recommended Text
            SizedBox(
              height: Dimensions.height30,
            ),
            Container(
              margin: EdgeInsets.only(left: Dimensions.width30),
              child: BigText(text: "Recommended Service"),
            ),

            //List of Services
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount:serviceController.AllServiceList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getserviceDetails(
                          serviceController.AllServiceList[index].id));
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
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius20),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        serviceController
                                            .AllServiceList[index]
                                            .image))),
                          ),
                          //Text
                          Expanded(
                            child: Container(
                              height: Dimensions.listViewTextContSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight:
                                  Radius.circular(Dimensions.radius20),
                                  bottomRight:
                                  Radius.circular(Dimensions.radius20),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: Dimensions.width10,
                                    right: Dimensions.width10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    BigText(
                                        text:
                                        serviceController
                                            .AllServiceList[
                                        index]
                                            .name),
                                    SizedBox(
                                      height: Dimensions.height10,
                                    ),
                                    SmallText(
                                        text:
                                        serviceController
                                            .AllServiceList[
                                        index]
                                            .category),
                                    SizedBox(
                                      height: Dimensions.height10,
                                    ),
                                    Row(
                                      children: [
                                        IconText(
                                            icon: Icons.location_on,
                                            text: serviceController.AllServiceList[index].distance,
                                            iconColor: Colors.black),
                                        SizedBox(
                                          width: Dimensions.width30,
                                        ),
                                        IconText(
                                            icon: Icons.access_time,
                                            text: serviceController.AllServiceList[index].duration.substring(0,serviceController.AllServiceList[index].duration.length - 1),
                                            iconColor: Colors.black),
                                        SizedBox(
                                          width: Dimensions.width30,
                                        ),
                                        //IconText(icon: Icons.money, text: recommendedServiceController.RecommendedServiceList[index].price, iconColor: Colors.black)
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
                })
          ]);
        });
  }

  //Image Carousel Builder
  Widget _buildPageItem(int index, ServiceModel popularService) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getserviceDetails(popularService.id));
            },
            child: Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.width10, right: Dimensions.width10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  color: Colors.black,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(popularService.image))),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.width30,
                  right: Dimensions.width30,
                  bottom: Dimensions.height30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0, 5),
                    ),
                    BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                    BoxShadow(color: Colors.white, offset: Offset(5, 0))
                  ]),
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimensions.height15,
                    left: Dimensions.width15,
                    right: Dimensions.width15),
                child: AppColumn(
                  text: popularService.name,
                  price: popularService.price,
                  rating: popularService.rating,
                  reviewCount: popularService.reviewCount,
                  category: popularService.category,
                  distance: popularService.distance,
                  duration: popularService.duration,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
