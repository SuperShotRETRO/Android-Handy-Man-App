import 'package:finalhandyman/pages/categorypage/category_page.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:finalhandyman/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class CategoryList extends StatelessWidget {
  CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var categories = ['Plumber','Electrian','Pest Control','Barber'];


    return Container(
      height: 120,
      child: ListView.builder(
          itemCount: categories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            return card(imageString: categories[index],imageLocation: 'TestImages/wrench.png');
          }),
    );
  }
}

class card extends StatelessWidget {
  final String imageLocation;
  final String imageString;
  const card({super.key,
    required this.imageLocation,
    required this.imageString
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(10,10,10,15),
        child:PhysicalModel(
              color: Colors.white,
              elevation: 8,
              shadowColor: Colors.blue,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: (){
                  Get.toNamed(RouteHelper.getCategoryPage(imageString));
                },
                child: Container(
                  width: 100,
                  height: 100,
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: 10),
                    title: Image.asset(imageLocation,height: 40,width: 40,),
                    subtitle: Container(
                      padding: EdgeInsets.only(top: 8),
                      child:Text(imageString,textAlign: TextAlign.center,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                    )
                  ),
                ),
              ),
            ),


    );
  }
}