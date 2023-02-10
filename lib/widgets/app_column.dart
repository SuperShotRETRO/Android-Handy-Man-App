import 'package:finalhandyman/widgets/small_text.dart';
import 'package:finalhandyman/widgets/icon_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/dimension.dart';
import 'big_text.dart';

class AppColumn extends StatelessWidget {
  final String text;
  final String price;
  final String rating;
  final int reviewCount;
  final String category;
  const AppColumn(
      {Key? key,
      required this.text,
      required this.price,
      required this.rating,
      required this.reviewCount,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Heading
        BigText(
          text: text,
          size: Dimensions.font26,
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
        //Category
        SmallText(text: category),
        SizedBox(
          height: Dimensions.height10,
        ),
        //Rating and Review
        Row(
          children: [
            //Stars
            Wrap(
              children: List.generate(
                  int.parse(rating), (index) => Icon(Icons.star, color: Colors.black,size: Dimensions.iconSize16,)),
            ),
            SizedBox(
              width: 10,
            ),
            //Rating
            SmallText(text: rating),
            SizedBox(
              width: 10,
            ),
            //Review
            SmallText(text: "$reviewCount"),
            SizedBox(
              width: 5,
            ),
            SmallText(text: "Reviews")
          ],
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
        //Info Row
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
                iconColor: Colors.black),
            SizedBox(
              width: Dimensions.width30,
            ),
            IconText(icon: Icons.money, text: price, iconColor: Colors.black)
          ],
        )
      ],
    );
  }
}
