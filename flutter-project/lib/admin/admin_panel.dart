import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/admin/admin_panel_controller.dart';
import 'package:movementfarmacy/admin/employes/add_employ.dart';
import 'package:movementfarmacy/admin/advertisements/advertisement.dart';
import 'package:movementfarmacy/admin/advertisements/advertisement_controller.dart';
import 'package:movementfarmacy/admin/customers/customers_view.dart';
import 'package:movementfarmacy/admin/customers/cutomers_controller.dart';
import 'package:movementfarmacy/admin/employes/employes_controller.dart';
import 'package:movementfarmacy/admin/employes/employs_view.dart';
import 'package:movementfarmacy/admin/new_orders/new_order_controller.dart';
import 'package:movementfarmacy/admin/purchase/purchase.dart';
import 'package:movementfarmacy/admin/purchase/purchase_controller.dart';
import 'package:movementfarmacy/main.dart';
import 'package:movementfarmacy/static/my_urls.dart';

import '../views/widgets/MyText.dart';
import 'categories/category_screen.dart';
import 'new_orders/new_order.dart';
class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  void initState() {
    Get.put(AdminPanelController());
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar:AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor:const Color(0xFF0BB000),
          shadowColor: null,
          title: Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
              ),
              Expanded(child:
              Center(
                child: MyText(
                  txt: "لوحة التحكم",
                  color:Colors.white,
                ),
              )),
              SizedBox(
                width: 40,
                height: 40,
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 InkWell(
                   onTap: (){
                     if(prefs?.getString("admin_position") != null)
                     {
                       if(prefs?.getString("admin_position") =="admin"||prefs?.getString("admin_position")=="country_manager")
                       {
                         Get.to(() =>const NewOrder(
                           title:"طلبات جديدة" ,
                         ),
                             binding: BindingsBuilder(() {
                               Get.put(NewOrderController(
                                   status: 0
                               ));
                             }));
                       }

                     }

                   },
                   child: Container(
                     width: 140,
                     height: 120,
                     padding: EdgeInsets.all(8.0),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.grey.shade300
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         MyText(
                           txt:"طلبات جديدة",
                           size: 16,
                         ),

                         Container(
                           padding: EdgeInsets.all(4.0),
                           alignment: Alignment.center,
                           height: 50,
                           width: 50,
                           decoration: BoxDecoration(
                               border: Border.all(color: Colors.green,width: 2),
                               borderRadius: BorderRadius.circular(50)
                           ),
                           child: GetBuilder<AdminPanelController>(
                             builder: (adminCtrl) {
                               return  FittedBox(
                                 child:adminCtrl.isFetched? MyText(
                                   txt: "${adminCtrl.counter0}",
                                   color: Colors.red,
                                 ):Icon(Icons.question_mark_outlined,color: Colors.red,),
                               );
                             }
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
                 SizedBox(width: 20,),
                 InkWell(
                   child: Container(
                     width: 140,
                     height: 120,
                     padding: EdgeInsets.all(8.0),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.grey.shade300
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         MyText(
                           txt:"طلبات قيد التوصيل",
                           size: 16,
                           textAlign: TextAlign.center,
                         ),
                         Container(
                           padding: EdgeInsets.all(4.0),
                           alignment: Alignment.center,
                           height: 50,
                           width: 50,
                           decoration: BoxDecoration(
                               border: Border.all(color: Colors.green,width: 2),
                               borderRadius: BorderRadius.circular(50)
                           ),
                           child: GetBuilder<AdminPanelController>(
                             builder: (adminCtrl) {
                               return FittedBox(
                                 child:adminCtrl.isFetched? MyText(
                                   txt: "${adminCtrl.counter1}",
                                   color: Colors.blueAccent,
                                 ):Icon(Icons.question_mark_outlined,color: Colors.red,),
                               );
                             }
                           ),
                         ),
                       ],
                     ),
                   ),
                   onTap: (){
                     Get.to(() =>const NewOrder(
                       title:"طلبات قيد التوصيل" ,
                     ),
                         binding: BindingsBuilder(() {
                           Get.put(NewOrderController(
                               status: 1
                           ));
                         }));
                   },
                 ),
               ],
             ),
              SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[100]
              ),
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  Buttons.squareButton(
                      buttonText:"بيانات المستخدمين",
                      icon: Icons.people,
                      onTap: (){
                        Get.to(() =>const CustomersView(),
                            binding: BindingsBuilder(() {
                              Get.put(CustomersController());
                            }));
                      }
                  ),
                  Buttons.squareButton(
                      buttonText:"اضافة،تعديل منتج",
                      icon: Icons.add,
                      onTap: (){
                        if(prefs?.getString("admin_position") != null)
                        {
                          if(prefs?.getString("admin_position") =="admin"||prefs?.getString("admin_position")=="country_manager")
                          {
                            Get.to(()=>CategoryScreen());
                          }

                        }
                      }
                  ),
                  Buttons.squareButton(
                      buttonText:"الاعلانات",
                      icon: Icons.signpost_outlined,
                      onTap: (){
                      if(prefs?.getString("admin_position") != null)
                        {
                          if(prefs?.getString("admin_position") =="admin"||prefs?.getString("admin_position")=="country_manager")
                            {
                              Get.to(() => Advertisement(),
                                  binding: BindingsBuilder(() {
                                    Get.put(AdvertisementController());
                                  }));
                            }

                        }
                      }
                  ),
                  Buttons.squareButton(
                      buttonText:"المبيعات",
                      icon: Icons.monetization_on_outlined,
                      onTap: (){
                        Get.to(() => Purchase(),
                            binding: BindingsBuilder(() {
                              Get.put(PurchaseController());
                            }));
                      }
                  ),

                  if(prefs?.getString("admin_position") =="admin"||prefs?.getString("admin_position")=="country_manager")
                    Buttons.squareButton(
                      buttonText:"اضافة موظف",
                      icon: Icons.monetization_on_outlined,
                      onTap: (){
                        if(prefs?.getString("admin_position") != null)
                        {
                          if(prefs?.getString("admin_position") =="admin"||prefs?.getString("admin_position")=="country_manager")
                          {
                            Get.to(()=>AddEmploy());
                          }

                        }
                      }
                  ),
                  if(prefs?.getString("admin_position") =="admin"||prefs?.getString("admin_position")=="country_manager")
                    Buttons.squareButton(
                        buttonText:"بيانات الموظفين",
                        icon: Icons.monetization_on_outlined,
                        onTap: (){
                          if(prefs?.getString("admin_position") != null)
                          {
                            if(prefs?.getString("admin_position") =="admin"||prefs?.getString("admin_position")=="country_manager")
                            {
                              Get.to(() => EmploysView(),
                                  binding: BindingsBuilder(() {
                                    Get.put(EmploysController());
                                  }));
                            }

                          }
                        }
                    ),
                  Buttons.squareButton(
                      buttonText:"تسجيل الخروج",
                      icon: Icons.monetization_on_outlined,
                      onTap: ()async{
                        if(MyUrls.adminPosition=="delivery")
                        {
                          //
                          if(MyUrls.adminCountry==0)
                          {
                            //اشراك جميع الموصلين في البلد بنفس الاشعار
                            await FirebaseMessaging.instance.unsubscribeFromTopic('yemeni_delivery');
                          }
                          else if(MyUrls.adminCountry==1)
                          {
                            await FirebaseMessaging.instance.unsubscribeFromTopic('saudi_delivery');
                          }
                        }
                        prefs?.remove("adminpassword");
                        prefs?.remove("admin_position");
                        prefs?.remove("admin_contrller_phone");
                        prefs?.remove("admin_country");
                        Get.back();
                      }
                  ),
                ],
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}
class Buttons{
 static Widget inkWellButton(
 {
   required void Function()? onTap,
   required String buttonText,
   required IconData icon
 }){
   return InkWell(
    borderRadius: BorderRadius.circular(9),
     onTap:onTap,
     child: Container(
       margin: EdgeInsets.all(8.0),
       height: 40,
       width: 250,
       decoration: BoxDecoration(
         color:   const Color(0xFF0BB000),
         borderRadius: BorderRadius.circular(9),
       ),
       child: FittedBox(
         child:Row(
           children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: MyText(
                 txt: buttonText,
                 color: Colors.white,
                 size: 18,
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(right: 8.0),
               child: Icon(icon,color: Colors.white,size: 27,),
             )
           ],
         ),
       ),
     ),
   );
 }
 static Widget squareButton(
 {
   required void Function()? onTap,
   required String buttonText,
   required IconData icon
 })
 {
   return InkWell(
     onTap:onTap,
     child: Container(
       width: 140,
       padding: EdgeInsets.all(8.0),
       decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10),
           color: Colors.grey.shade300
       ),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [
           Container(
             child: MyText(
               textAlign: TextAlign.center,
               txt:buttonText,
               size: 16,
             ),
           ),

           Container(
             padding: EdgeInsets.all(4.0),
             alignment: Alignment.center,
             height: 50,
             width: 50,
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(50)
             ),
             child:
             FittedBox(child: Icon(icon,size: 40,)),
           ),
         ],
       ),
     ),
   );

 }
}