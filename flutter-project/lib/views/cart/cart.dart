import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/static/my_urls.dart';
import 'package:movementfarmacy/views/cart/cart_controller.dart';
import 'package:movementfarmacy/views/widgets/MyText.dart';
import 'package:movementfarmacy/views/widgets/custom_dialog.dart';
import 'package:movementfarmacy/views/widgets/customImage.dart';

import '../../static/fonts.dart';
import '../bills/paymenents.dart';
import '../bills/payment_controller.dart';
class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  // double total = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<CartController>(
          builder: (cartController) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Color(0xFF0BB000),
                shadowColor: null,
                title: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.arrow_back_ios_new, color: Colors.white,)),
                    ),
                    Expanded(child:
                    Center(
                      child: MyText(
                        txt: "السلة",
                        color: Colors.white,
                      ),
                      // child: Text("الأدوية",
                      //   style: TextStyle(color:
                      //   Colors.white.withOpacity(.7),
                      //   fontFamily:'Black.otf' ),)

                    )),
                    InkWell(
                        onTap: () {
                          cartController.dropAllItems();

                        },
                        splashColor: Colors.grey.withOpacity(.5),
                        child: Container(
                          // alignment: Alignment.center,
                          width: 40,
                          height: 40,
                            child: Icon(Icons.delete,
                              color: Color.fromARGB(200, 220, 50, 50),)
                          // child: MyText(txt: "تفريغ",size: 16,color: Colors.white,),
                        ))
                  ],
                ),
              ),
              body:cartController.products.length>0? ListView.builder(
                itemCount: cartController.products.length+1,
                itemBuilder: (context, index) {

                  print(index.toString());
                  //this condition for give space between floating bottom and list
                  if(index>=cartController.products.length) {
                    return const SizedBox(height: 80,);
                  }
                  return Dismissible(
                    background: Card(
                      color: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete)),
                      ),
                    ),
                    confirmDismiss: (g)async{

                      return !cartController.waitDelete;
                    },
                    onDismissed: (direction)async {
                      await cartController.delete(index,cartController.products[index].id!);
                    },
                    //${Random().nextInt(1000)
                    key: ValueKey('${cartController.products[index].id}${Random().nextInt(1000)}'),
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8.0),
                            height: 70,
                            width: 70,
                            child: CustomImage(
                              image:'${MyUrls.imgUrl}${cartController.products[index].img!}',
                              radius: 0.0, isShadow: false, fit: BoxFit.cover,),
                          ),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      txt: cartController.products[index].name,
                                      family: Fonts.medium,
                                      size: 15,
                                    ),
                                    MyText(
                                      txt: cartController.products[index].amount.toString(),
                                      family: Fonts.medium,
                                      size: 15,
                                    ),
                                    Row(
                                      children: [
                                        MyText(
                                          txt: "${cartController.products[index]
                                              .price! *
                                              cartController.mounts[index]} ",
                                          family: Fonts.blackOtf,
                                          size: 18,
                                          color: Colors.yellow.shade800
                                              .withOpacity(.8),
                                        ),
                                        MyText(
                                          txt: "ريال",
                                          size: 11,
                                          family: Fonts.blackTtf,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      left: 20.0, right: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (cartController.mounts[index] <
                                              1000) {
                                            cartController.encrement(index);
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(50),
                                        splashColor: Colors.grey.withOpacity(
                                            0.5),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.greenAccent
                                                    .shade200.withOpacity(0.2),
                                                border: Border.all(
                                                    color: Color(0xFF0BB000)),
                                                borderRadius: BorderRadius
                                                    .circular(50)
                                            ),
                                            child: Icon(Icons.add,
                                              color: Colors.black.withOpacity(
                                                  0.5), size: 22,)),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: MyText(
                                            txt: cartController.mounts[index]
                                                .toString(),
                                            family: Fonts.blackTtf,
                                            size: 16,
                                            fontweight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                            if (cartController.mounts[index] >1) {
                                              cartController.decrement(index);
                                            }
                                        },
                                        borderRadius: BorderRadius.circular(50),
                                        splashColor: Colors.grey.withOpacity(
                                            0.5),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.greenAccent
                                                    .shade200.withOpacity(0.2),
                                                border: Border.all(
                                                    color: Color(0xFF0BB000)),
                                                borderRadius: BorderRadius
                                                    .circular(50)
                                            ),
                                            child: Icon(Icons.remove,
                                              color: Colors.black.withOpacity(
                                                  0.5), size: 22,)),
                                      ),


                                      // InkWell(
                                      //   child: Container(
                                      //     decoration:BoxDecoration(
                                      //       color: Color(0xFF78AD50),
                                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                                      //     ),
                                      //     margin: EdgeInsets.only(left: 20),
                                      //     alignment: Alignment.center,
                                      //     height: 40,
                                      //     width: 100,
                                      //     child: Row(
                                      //       mainAxisAlignment: MainAxisAlignment.center,
                                      //       children: [
                                      //         MyText(
                                      //           txt: "شراء",
                                      //           family: Fonts.blackOtf,
                                      //           size: 15,
                                      //           color: Colors.white,
                                      //         ),
                                      //         Icon(Icons.shopping_cart,color: Colors.white,)
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },):
              cartController.isLoad==true?Center(child: CircularProgressIndicator(),):
                  cartController.connectionError==true?
                  InkWell(child: Center(child: Icon(Icons.refresh,size: 30,color: Colors.blue,),),
                  onTap: (){cartController.fetch(); },):
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Center(child: Icon(Icons.remove_shopping_cart_outlined,size: 50,color:  Colors.grey,),),
                  Center(child: MyText(txt: "السلة فارغة",color: Colors.grey,),),

                ],),


              floatingActionButton:cartController.products.length>0? Container(
                // margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Color(0xFF0BB000), blurRadius: 2.0),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  // borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Wrap(
                      children: [
                        MyText(txt: "الإجمالي: ",
                          size: 15,
                          color: Color(0xFF0BB000),),
                        Container(
                          child: Text(
                            "${cartController.totalPrice}",
                            style: TextStyle(
                                height: 1,
                                color: Colors.orange,
                                fontSize: 21,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(top: 5),
                          child: Text("ريال", style: TextStyle(
                              color: Color(0xFF0BB000), fontSize: 13),),
                        )
                      ],
                    ),
                    InkWell(
                      child: Container(
                        height: 45,
                        width: 125,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFF0BB000),
                            borderRadius: BorderRadius.circular(10)),
                        child:
                        MyText(txt: "تنفيذ الطلب",
                          fontweight: FontWeight.bold,
                          size: 16,
                          color: Colors.white,),
                      ),
                      onTap: () async {
                        print(Get.currentRoute);
                       bool result= await cartController.addOrder();
                       print("hhhhhhhhhhhhhhhhhhhhhh");
                       print("Get.isDialogOpen -=>${Get.isDialogOpen}");
                        if(result==true)
                        CustomDialog.showImageAlertDialog(
                            title: Column(children: [
                              MyText(txt: "تم ارسال الطلب",),
                              InkWell(child:MyText(txt: "ذهاب الى المشتريات",size: 14,color: Colors.blue,textDecoration: TextDecoration.underline) ,
                              onTap: (){
                                Get.back();
                                Get.off(() => Payments(), binding: BindingsBuilder(() {
                                  Get.put(PaymentController());
                                }));
                                // Get.offAndToNamed(AppRoutes.payments);
                                },),
                              SizedBox(height: 5,),
                            ],),
                            img: "images/tick.png", //successful dialog image
                            onPressed: () {
                              Get.back();
                            }
                        );
                      },
                    )
                  ],
                ),
              ):null,
              floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerDocked,

            );
          }
      ),
    );
  }
}


