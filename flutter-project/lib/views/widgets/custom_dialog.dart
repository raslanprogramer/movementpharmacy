import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/static/fonts.dart';

import 'MyText.dart';

class CustomDialog {
  static void showImageAlertDialog({
    // required BuildContext context,
    required String img,
    required Widget title,
    required void Function()? onPressed,
    double iconHeight=120,
    Widget? inkWell,
    String buttonText="رجوع"
}) {
    Get.dialog(
      Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        insetPadding: EdgeInsets.symmetric(horizontal: Get.width/6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(img,height: iconHeight),
           FittedBox(
             child: Container(
               alignment: Alignment.center,
                 width: 180,
                 child: title),
           ),
           inkWell?? InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap:onPressed,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                height: 40,
                width: 180,
                decoration: BoxDecoration(
                  color:   const Color(0xFF0BB000),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: FittedBox(
                    child: MyText(
                      txt: buttonText,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
 static  dialogExitFromApp()
  {
    Get.dialog(
      Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(20.0))),
          // insetPadding: EdgeInsets.symmetric(horizontal: Get.width/6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                ),
                child: const MyText(
                  color: Colors.white,
                  size: 18,
                  txt: "خروج",
                ),
              ),
              // Image.asset(img,height: iconHeight),
              SizedBox(height: 20,),
              Container(
                  alignment: Alignment.center,
                  child:MyText(txt: "تسجيل الخروج من التطبيق؟",size: 16,family: Fonts.medium,)),
             Row(
               children: [
                Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap:(){
                        if(Platform.isAndroid)
                          {
                            exit(0);
                          }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10,top: 5),
                        height: 40,
                        decoration: BoxDecoration(
                          color:   const Color(0xFF0BB000),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Center(
                          child: FittedBox(
                            child: MyText(
                              txt: "موافق",
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ) ),
                 Expanded(
                     child: Container(
                       margin: const EdgeInsets.only(left: 10,top: 5,right: 5),
                       child: InkWell(
                         borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                         child: Container(
                           height: 40,
                           alignment: Alignment.center,
                           child: const MyText(txt: "إلغاء",size: 18),
                         ),
                         onTap: (){
                           Get.back();
                         },
                       ),
                     ))
               ],
             ),
              const SizedBox(height: 10,)
            ],
          ),
        ),
      ),

    );
  }
}
