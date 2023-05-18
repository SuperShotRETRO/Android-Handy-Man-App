import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/route_helper.dart';
import '../../utils/dimension.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({Key? key}) : super(key: key);

  UserDataController userDataController = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    var orderList;
    userDataController.getOrderInfo();
    orderList = userDataController.OrdersList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.offNamed(RouteHelper.getInitial());
          },
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: Dimensions.height30,
            ),
            Center(
              child: Container(
                  height: Dimensions.height45,
                  child: Text(
                    "Orders",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.font26 * 1.3),
                  )),
            ),
            SizedBox(
              height: Dimensions.height20,
            ),
            SingleChildScrollView(
              child: GetBuilder<UserDataController>(
                  init: UserDataController(),
                  initState: (_) {},
                  builder: (userDataController) {
                    userDataController.getCurrentUserData();
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              //Get.toNamed(RouteHelper.getserviceDetails(categoryList[index].id));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.width20,
                                  right: Dimensions.width20,
                                  bottom: Dimensions.height10),
                              child: Row(
                                children: [
                                  //Text
                                  Expanded(
                                    child: Container(
                                      height: Dimensions.listViewTextContSize*1.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(Dimensions.radius20)
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0.0, 5),
                                              blurRadius: 6.0
                                          )
                                        ],
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: Dimensions.width15,right: Dimensions.width10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BigText(text: orderList[index].name),
                                            SizedBox(height: Dimensions.height10,),
                                            SmallText(text: orderList[index].orderId),
                                            SizedBox(height: Dimensions.height10*0.5,),
                                            SmallText(text: orderList[index].price),
                                            SizedBox(height: Dimensions.height10*0.5,),
                                            SmallText(text: orderList[index].datetime),
                                            SizedBox(height: Dimensions.height10*0.5,),
                                            SmallText(text: orderList[index].status,),
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
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
