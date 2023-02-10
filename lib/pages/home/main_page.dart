import 'package:finalhandyman/pages/home/main_page_body.dart';
import 'package:finalhandyman/utils/dimension.dart';
import 'package:finalhandyman/widgets/big_text.dart';
import 'package:finalhandyman/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
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
          Expanded(child: SingleChildScrollView(
            child: MainPageBody(),
          )),
        ],
      ),
    );
  }
}
