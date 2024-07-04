import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/app_routes.dart';
import 'package:movementfarmacy/main.dart';
import 'package:movementfarmacy/static/fonts.dart';
import 'package:movementfarmacy/static/my_urls.dart';
import 'package:movementfarmacy/theme/AppColor.dart';
import 'package:movementfarmacy/views/bills/payment_controller.dart';
import 'package:movementfarmacy/views/cart/cart.dart';
import 'package:movementfarmacy/views/cart/cart_controller.dart';
import 'package:movementfarmacy/views/drags/drags_controller.dart';
import 'package:movementfarmacy/views/home/controllers/user_advertisment_controller.dart';
import 'package:movementfarmacy/views/home/controllers/category_controller.dart';
import 'package:movementfarmacy/views/bills/paymenents.dart';
import 'package:movementfarmacy/views/widgets/MyText.dart';
import 'package:movementfarmacy/views/widgets/custom_dialog.dart';
import '../../login_screen/location_setting.dart' as my_get_location_library;
import '../../static/helper_fuctions.dart';
import '../drags/drags.dart';
import '../widgets/customImage.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  bool canPop = false;
  final CarouselController _carouselController = CarouselController();

  //طلب إذن الاشعار
  Future<void> getPermissions()async
  {
    FirebaseMessaging messaging=FirebaseMessaging.instance;
    NotificationSettings settings=await messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: false,
      sound: true,
      announcement: false,
      criticalAlert: false,
      provisional: false
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {

      //قمنا بعملية اشراك المستحدم بالاشعارات العامة في البلد المعين
      if(MyUrls.userCountry==0)
        {
          await messaging.subscribeToTopic('yemeni_notification');
        }
      else if(MyUrls.userCountry==1)
        {
          await messaging.subscribeToTopic('saudi_notification');
        }
    }
  }

  // String? _token;
  // String? initialMessage;
  // bool _resolved = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPermissions();


  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        if (Platform.isAndroid) {
          CustomDialog.dialogExitFromApp();
        }
        //for IOS
        else {
          setState(() {
            canPop = true;
          });
        }
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3 + 90,
                    color: const Color(0xFFFDFDFE),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryMainGreen,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40))
                    ),

                  ),
                  Positioned(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height / 3 - 80,
                    child: Container(
                      // color: Colors.deepPurpleAccent,
                      // alignment: Alignment.center,
                      height: 150,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: const EdgeInsets.only(top: 10),
                      child: GetBuilder<UserAdvertisementController>(
                        init: UserAdvertisementController(),
                        builder: (advController) {
                          return advController.adverts.length>0?CarouselSlider(
                            carouselController: _carouselController,
                            options: CarouselOptions(

                              // aspectRatio: 2.0,
                              autoPlayInterval: const Duration(seconds: 8),
                              // height: 200,
                              enlargeCenterPage: true,
                              // disableCenter: true,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                              },
                            ),
                            items: List.generate(
                              advController.adverts.length,
                                  (index) =>
                                  CustomImage(
                                      image: '${MyUrls.imgUrl}${advController.adverts[index].img!}',
                                      isNetwork: true,
                                      radius: 15,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.9,
                                      isShadow: false),
                            ),
                          )
                          :CarouselSlider(
                            carouselController: _carouselController,
                            options: CarouselOptions(

                              // aspectRatio: 2.0,
                              autoPlayInterval: const Duration(seconds: 8),
                              // height: 200,
                              enlargeCenterPage: true,
                              // disableCenter: true,
                              viewportFraction: 1.0,
                              autoPlay: false,
                              onPageChanged: (index, reason) {
                              },
                            ),
                            items: List.generate(
                              1,
                                  (index) =>
                                  CustomImage(
                                      image: "images/img.png",
                                      isNetwork: false,
                                      radius: 15,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.9,
                                      isShadow: false),
                            ),
                          );
                        }
                      ),
                    ),),
                  Positioned(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * .07,
                    right: 15,
                    child: Container(
                        color: Colors.transparent,
                        // width: 40,
                        // height: 40,
                        child: PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert, color: Colors.white, size: 25,),
                          color: Colors.white,
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) =>
                          [

                            PopupMenuItem(
                                onTap: () {
                                  Get.to(() =>const Payments(),
                                      binding: BindingsBuilder(() {
                                        Get.put(PaymentController());
                                      }));
                                }, value: 1,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: MyText(txt: "المشتريات",
                                      size: 12,
                                      color: Colors.black,))),
                            PopupMenuItem(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                onTap: () async {
                                  HelperFunctions.makePhoneCall(MyUrls.adminPhone);
                                }, value: 2,
                                child: const Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    MyText(txt: "تواصل معنا  ",
                                      size: 12,
                                      color: Colors.black,),
                                    SizedBox(width: 15,),
                                    Icon(Icons.call,
                                      color: AppColors.primaryMainGreen,),
                                  ],
                                )),
                            PopupMenuItem(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2),
                                onTap: () {
                                  HelperFunctions.openWhatsAppChat(MyUrls.adminPhone);
                                }, value: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    const MyText(txt: " واتس اب  ",
                                      size: 12,
                                      color: Colors.black,),
                                    const SizedBox(width: 20,),
                                    SizedBox(
                                      // margin: EdgeInsets.only(left: 10),
                                      width: 25,
                                      height: 25,
                                      child: Image.asset("images/whatsapp.png"),
                                    ),
                                  ],
                                )),

                            ////////////
                            //خاص بمدير الموقع
                            ///////////
                            PopupMenuItem(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2),
                                onTap: () {
                                  Get.toNamed(AppRoutes.adminLoging);
                                }, value: 4,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    MyText(txt: "لوحة التحكم  ",
                                      size: 12,
                                      color: Colors.black,),
                                    SizedBox(width: 10,),
                                    SizedBox(
                                      // margin: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.admin_panel_settings_outlined,
                                        color: AppColors.primaryMainGreen,),
                                    ),
                                  ],
                                )),

                          ],
                        )),
                  ),

                ],
              ),
              Expanded(
                child: GetBuilder<CategoryController>(
                    init: CategoryController(),
                    builder: (categoryController) {
                      return categoryController.categories.length > 0 ? Container(
                          color: const Color(0xFFFDFDFE),
                          // color: Colors.grey,
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Wrap(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  alignment: WrapAlignment.end,
                                  runSpacing: 20,
                                  children: [
                                    for(int i = 0; i <
                                        categoryController.categories.length; i++)
                                      InkWell(
                                        onTap: () {
                                          // Get.to(() => Drags());
                                          //

                                          Get.to(() => Drags(),
                                              binding: BindingsBuilder(() {
                                                Get.put(DragsController(
                                                    categoryId: categoryController
                                                        .categories[i].id!
                                                ));
                                              }));
                                        },
                                        child: Container(
                                          width: 110,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            // color: Colors.green,
                                              borderRadius: BorderRadius.circular(
                                                  10)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: [
                                              CustomImage(
                                                borderRadius: BorderRadius
                                                    .circular(5),
                                                isNetwork: true,
                                                width: 80,
                                                height: 80,
                                                image: '${MyUrls
                                                    .imgUrl}${categoryController
                                                    .categories[i].icon!}',
                                                radius: 0.0,
                                                isShadow: false,
                                                fit: BoxFit.cover,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: MyText(
                                                  txt: categoryController
                                                      .categories[i].name,
                                                  size: 16,
                                                  family: Fonts.medium,
                                                  textAlign: TextAlign.center,),)
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          )


                      ) :
                          categoryController.isLoad?Center(child: CircularProgressIndicator(),):
                          categoryController.connectionError==true?
                          Center(child:InkWell(
                            child: Icon(Icons.refresh,size: 30,color: Colors.blue,),
                            onTap: (){categoryController.fetch();},
                          ),):
                      Column(children: [
                        Center(child: MyText(txt: "هناك خطأ",),),
                        InkWell(child: Center(child: MyText(txt: "عليك الاتصال بخدمة العملاء",color: Colors.blue,textDecoration: TextDecoration.underline,),)
                        ,onTap: (){HelperFunctions.makePhoneCall(MyUrls.adminPhone);},),
                      ],mainAxisAlignment: MainAxisAlignment.center,);
                    }
                ),
              )

            ],
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
            decoration: BoxDecoration(
                color: AppColors.primaryMainGreen,
                borderRadius: BorderRadius.circular(13)
            ),
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => Cart(),
                            binding: BindingsBuilder(() {
                              Get.put(CartController(
                              ));
                            }));
                      },
                      child: Padding(
                        // color: Colors.black,
                        padding: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 12),
                        // color: Colors.black,
                        child: Icon(
                          Icons.shopping_cart, color: Colors.white, size: 27,),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: InkWell(
                        onTap: ()async
                          {
                            my_get_location_library.getUserLocation();
                          },
                          child: Icon(
                            Icons.home, color: Colors.greenAccent.shade200,
                            size: 27,)),
                    )),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
