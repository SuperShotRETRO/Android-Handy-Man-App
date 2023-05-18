import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalhandyman/models/address_model.dart';
import 'package:finalhandyman/models/service_model.dart';
import 'package:finalhandyman/routes/route_helper.dart';
import 'package:finalhandyman/utils/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:finalhandyman/pages/checkout/razorpay_credentials.dart' as razorCredentials;
import 'package:http/http.dart' as http;

import '../../controllers/service_controller.dart';
import '../../controllers/user_data_controller.dart';
import '../../utils/directions_repository.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

class CheckoutPage extends StatefulWidget {
  int id;
  CheckoutPage({Key? key, required this.id}) : super(key: key);

  ServiceController serviceController = Get.put(ServiceController());
  UserDataController userDataController = Get.put(UserDataController());


  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

enum Options {cash, online}

class _CheckoutPageState extends State<CheckoutPage> {

  Options _option = Options.cash;
  final _razorpay = Razorpay();
  var addressId = 0;

  String datetime = DateTime.now().toString();

  @override
  void initState(){
    widget.userDataController.getAddress();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,_handleExternalWallet);
    });
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response){
    print(response);
    verifySignature(
      signature : response.signature,
      paymentId : response.paymentId,
      orderId : response.orderId,
    );
    addOrder(uid: widget.userDataController.CurrentUserData.uid, orderId: response.orderId!,service: widget.serviceController.AllServiceList[widget.id]);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Container(
              height: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
              ),
              child: Column(
                children: [
                  Text('Order Confirmed'),
                  SizedBox(height: 10,),
                  TextButton(onPressed: (){
                    Get.offNamed(RouteHelper.getInitial());
                  }, child: Text('Ok'))
                ],
              )
          );
        });
  }

  void _handlePaymentError(PaymentFailureResponse response){
    print(response);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message ?? '')));
  }

  void _handleExternalWallet(ExternalWalletResponse response){
    print(response);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.walletName ?? '')));
  }

  void createOrder(ServiceModel service) async {
    String username = razorCredentials.keyId;
    String password = razorCredentials.keySecret;
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount" : service.price,
      "currency" : "INR",
      "receipt" : "rif_01"
    };

    var res = await http.post(
      Uri.https(
        "api.razorpay.com", "v1/orders"
      ),
      headers: <String, String>{
        "Content-Type": "application/json",
        "authorization": basicAuth,
      },
      body: jsonEncode(body),
    );
    
    if(res.statusCode == 200){
      openGateway(jsonDecode(res.body)['id']);
    }
    print(res.body);
  }

  openGateway(String orderId) {
    var options = {
      'key' : razorCredentials.keyId,
      'amount': 100,
      'name' : 'RETRO Corp.',
      'order_id' : orderId,
      'description' : 'XYZ',
      'timeout' : 60*5,
      'prefill' : {
        'contact' : '9876543210',
        'email' : 'xyz@gmail.com',
      }
    };
    _razorpay.open(options);
  }

  verifySignature({String? signature, String? paymentId, String? orderId}) async {
    Map<String,dynamic> body = {
      'razorpay_signature' : signature,
      'razorpay_payment_id' : paymentId,
      'razorpay_order_id' : orderId,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}=''${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.https("localhost","razorpay_signature_verify.php"),
      headers: {
        "Content-type": "application/x-www-form-urlencoded",
      },
      body: formData,
    );
    print(res.body);
    if(res.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.body)));
    }
  }

  Future distdur() async {
    final directions =  await DirectionsRepository().getDirections("${widget.serviceController.AllServiceList[widget.id].lat}, ${widget.serviceController.AllServiceList[widget.id].long}", "${widget.userDataController.AddressDataList[addressId].lat}, ${widget.userDataController.AddressDataList[addressId].long}");
  }

  Future addOrder({required String uid,required String orderId,required ServiceModel service}) async {
    final docUser = FirebaseFirestore.instance.collection('user').doc(uid).collection('orders');
    final json = {
      'name': service.name,
      'order id': orderId,
      'price': service.price,
      'time': datetime,
      'status': 'ongoing',
    };
    await docUser.add(json);
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void dispose(){
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var addresslist = [];
    ServiceModel service = widget.serviceController.AllServiceList[widget.id];

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<UserDataController>(
        init: UserDataController(),
        initState: (_){},
        builder: (userDataController) {
          if(addresslist.isEmpty){
            userDataController.getAddress();
            addresslist = userDataController.AddressDataList;
          }
          return userDataController.AddressDataList.isEmpty?CircularProgressIndicator(color: Colors.black,):Stack(
            children: [
              SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          }, icon: Icon(CupertinoIcons.arrow_left)),
                      Expanded(
                          child: Text(
                        "Checkout",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: Dimensions.font26),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: Dimensions.height10),
                    child: Row(
                      children: [
                        //Text
                        Expanded(
                          child: Container(
                            height: Dimensions.listViewTextContSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimensions.radius20)
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 4),
                                    blurRadius: 6.0
                                )
                              ]
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: Dimensions.width10,right: Dimensions.width10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BigText(text: service.name),
                                  SizedBox(height: Dimensions.height10,),
                                  SmallText(text: service.category),
                                  SizedBox(height: Dimensions.height10,),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                    child: Text("Delivery Address",style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Address Box
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
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
                                    offset: Offset(0.0, 4),
                                    blurRadius: 6.0
                                )
                              ],
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: Dimensions.width15,right: Dimensions.width10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BigText(text: addresslist[addressId].name),
                                      SizedBox(height: Dimensions.height10,),
                                      SmallText(text: addresslist[addressId].addressline1),
                                      SizedBox(height: Dimensions.height10*0.5,),
                                      SmallText(text: addresslist[addressId].addressline2),
                                      SizedBox(height: Dimensions.height10*0.5,),
                                      SmallText(text: addresslist[addressId].city),
                                      SizedBox(height: Dimensions.height10*0.5,),
                                      SmallText(text: addresslist[addressId].pin),
                                    ],
                                  ),
                                  TextButton(onPressed: (){
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context){
                                          return Container(
                                            height: 400,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                            ),
                                            child: ListView.builder(
                                                itemCount: addresslist.length,
                                                itemBuilder: (context,index){
                                                  print(addresslist.length);
                                                  return _buildPageItem(addresslist[index],index);
                                                })
                                          );
                                        });
                                  }, child: Text('Change'))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                    child: Text("Choose Payment Mode",style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Cash option
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                        height: 50,
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 20,
                        ),
                        decoration: ShapeDecoration(
                          shadows: [BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 4),
                              blurRadius: 6.0
                          )],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _option == Options.cash?Colors.black: Colors.white,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Cash on delivery"),
                            Radio<Options>(
                              value: Options.cash,
                              groupValue: _option,
                              onChanged: (Options? value){
                                setState(() {
                                  _option = value!;
                                });
                              },
                              activeColor: Colors.black,
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Online Option
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                        height: 50,
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 20,
                        ),
                        decoration: ShapeDecoration(
                          shadows: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 4),
                                blurRadius: 6.0
                            )
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _option == Options.online?Colors.black: Colors.white,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Online Payment"),
                            Radio<Options>(
                              value: Options.online,
                              groupValue: _option,
                              onChanged: (Options? value){
                                setState(() {
                                  _option = value!;
                                });
                              },
                              activeColor: Colors.black,
                            )
                          ],
                        )),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Price'),
                        Text(service.price),
                      ],
                    ),
                  ),
                  //Checkout Button
                  Center(
                    child: TextButton(onPressed: (){
                      _option == Options.cash? {
                                          addOrder(
                                              uid: widget.userDataController
                                                  .CurrentUserData.uid,
                                              orderId:
                                                  'cod_${getRandomString(14)}',
                                              service: widget.serviceController
                                                  .AllServiceList[widget.id]),
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return Container(
                                height: 400,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                ),
                                child: Column(
                                  children: [
                                    Text('Order Confirmed'),
                                    SizedBox(height: 10,),
                                    TextButton(onPressed: (){
                                      Get.offNamed(RouteHelper.getInitial());
                                    }, child: Text('Ok'))
                                  ],
                                )
                            );
                          }),
                                        }
                                      :createOrder(service);
                    }, child: Text("Book")),
                  )
                ],
              ))
            ],
          );
        }
      ),
    );
  }

  Widget _buildPageItem(AddressModel addresslist, int index){
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20,top: Dimensions.height20),
      child: Row(
        children: [
          //Text
          Expanded(
            child: Container(
              height: Dimensions.listViewTextContSize*0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.radius20)
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 4),
                      blurRadius: 6.0
                  )
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: Dimensions.width15,right: Dimensions.width10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BigText(text: addresslist.name),
                        SizedBox(height: Dimensions.height10,),
                      ],
                    ),
                    TextButton(onPressed: (){
                      addressId = index;
                      setState(() {});
                      Navigator.pop(context);
                    }, child: Text('Change'))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


