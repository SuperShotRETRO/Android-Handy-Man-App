import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/controllers/user_data_controller.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);


  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var name, addline1, addline2, city, pin, lat, long;
  var namecontroller = TextEditingController();
  var addline1controller = TextEditingController();
  var addline2controller = TextEditingController();
  var citycontroller = TextEditingController();
  var pincontroller = TextEditingController();

  UserDataController userDataController = Get.put(UserDataController());

  Future addAdd(
      {required String uid,
      required String name,
      required String addline1,
      required String addline2,
      required String city,
      required String pin,}) async {


    await userDataController.getAddress();
    final json = {
      'name': name,
      'addline1': addline1,
      'addline2': addline2,
      'city': city,
      'pin': pin,
    };
    await FirebaseFirestore.instance.collection('user').doc(uid).collection('address').doc(
        "${userDataController.AddressDataList.length + 1}").set(json);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: UserDataController(),
        initState: (_) {},
        builder: (userDataController) {
          if (userDataController.lat == 0) {
            userDataController.getCurrentLocation();
            lat = userDataController.lat;
            long = userDataController.long;
          }
          print(lat);
          return userDataController.lat == 0
              ? CircularProgressIndicator(
                  color: Colors.black,
                )
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    title: Text('Add Address',style: TextStyle(color: Colors.black),),
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
                  body: SingleChildScrollView(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          height: 300,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  userDataController.lat,
                                  userDataController.long,
                                ),
                                zoom: 15),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                            child: Column(
                          children: [
                            TextFormField(
                              controller: namecontroller,
                              decoration: InputDecoration(
                                  label: Text('Full Name'),
                                  prefixIcon: Icon(CupertinoIcons.person)),
                              onChanged: (value) {
                                name = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: addline1controller,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(40)
                              ],
                              decoration: InputDecoration(
                                  label: Text('Address line 1'),
                                  prefixIcon: Icon(Icons.email_outlined)),
                              onChanged: (value){
                                addline1 = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: addline2controller,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(40)
                              ],
                              decoration: InputDecoration(
                                  label: Text('Address line 2'),
                                  prefixIcon: Icon(CupertinoIcons.phone)),
                              onChanged: (value){
                                addline2 = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: citycontroller,
                              decoration: InputDecoration(
                                  label: Text('City'),
                                  prefixIcon: Icon(CupertinoIcons.person)),
                              onChanged: (value){
                                city = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: pincontroller,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6)
                              ],
                              decoration: InputDecoration(
                                  label: Text('Pincode'),
                                  prefixIcon: Icon(CupertinoIcons.person)),
                              onChanged: (value){
                                pin = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  addAdd(uid: userDataController.CurrentUserData.uid, name: name, addline1: addline1, addline2: addline2, city: city, pin: pin,);
                                  Get.offNamed(RouteHelper.getInitial());
                                },
                                child: Text("Submit"),
                              ),
                            )
                          ],
                        ))
                      ),
                    ]),
                  ));
        });
  }
}
