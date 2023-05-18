import 'package:finalhandyman/pages/account_details/profile_screen.dart';
import 'package:finalhandyman/pages/favourite_page/favourite_page.dart';
import 'package:finalhandyman/pages/home/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HOmePageState();

}

class _HOmePageState extends State<HomePage> {


  int selectedIndex = 0;
  List pages=[
    MainPage(),
    FavouritePage(),
    ProfileScreen(),
  ];


  void onTapNav(int index){
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:pages[selectedIndex] ,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        selectedIconTheme: IconThemeData(),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,

        currentIndex: selectedIndex,
        onTap: onTapNav ,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: 'Home'),
          //BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
        ],
      ),

    );
  }
}
