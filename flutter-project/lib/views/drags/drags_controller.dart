import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movementfarmacy/models/product.dart';
import '../../static/my_urls.dart';
import '../widgets/MyText.dart';
import '../widgets/custom_dialog.dart';
class DragsController extends GetxController
{
  DragsController({required this.categoryId});
  List<Product> products=[];
  //هذه من أجل معرفة العناصر المراد ترحيلها الى السلة
  List<bool> isTaped=[];
  final int categoryId;
  // bool isReady=false;
  bool isLoad=false;
  bool connectionError=false;
  Future fetch()async
  {
    if(isLoad==false)
      {
        try {
          isLoad=true;
          update();//من أجل نظهر الدوران قيد التحميل
          final response = await http.get(
            Uri.parse('${MyUrls.apiUrl}product/$categoryId'),
            headers: MyUrls.getHeadersList
          ).timeout(MyUrls.timesOutInSeconds);
          print("i am in CategoryController in fetch function ,${response.statusCode.toString()}");
          if (response.statusCode == 200) {
            // final data = utf8.decode(response.bodyBytes);
            final element = jsonDecode(response.body);
            print(element);
            for(var cat in element['data'])
            {
              products.add(Product.fromJson(cat));
              isTaped.add(false);
            }
            isLoad=false;
            connectionError=false;
            update();/////////////
          }
          else {
            final element = jsonDecode(response.body);
            CustomDialog.showImageAlertDialog(
                title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
                img: "images/no-wifi.png", //successful dialog image
                buttonText: "حاول مجددا",
                onPressed: () {
                  fetch();
                  Get.back();
                }
            );
            isLoad=false;
            connectionError=true;
            update();/////////////
          }
        }on  TimeoutException catch(e)
        {
          isLoad=false;
          connectionError=true;
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"استغرق الأمر أكثر من اللازم ،تأكد من جودة الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              buttonText: "حاول مجددا",
              onPressed: () {
                fetch();
                Get.back();
              }
          );
          update();
        }
        on SocketException catch (e) {
          isLoad=false;
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              buttonText: "حاول مجددا",
              onPressed: () {
                fetch();
                Get.back();
              }
          );
          isLoad=false;
          connectionError=true;
          update();/////////////

        }catch (e) {
          isLoad=false;
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              buttonText: "حاول مجددا",
              onPressed: () {
                fetch();
                Get.back();
              }
          );
          isLoad=false;
          connectionError=true;
          update();/////////////

        }
      }
  }

  Future<bool> addToCart()async
  {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(50.0))),
        insetPadding: EdgeInsets.symmetric(horizontal: Get.width/2-30),
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircularProgressIndicator(color: Colors.green,),
          ),
        ),
      ),
    );

    List<int> productIds=[];
    for(int i=0;i<isTaped.length;i++)
      {
        if(isTaped[i]==true)
          {
            productIds.add(products[i].id!);
          }
      }
    if(productIds.length>0)
      {
        try {
          isLoad=true;
          int store_id=1;//////////////////////here we have to replace with store id that is in cachdata
          final response = await http.post(
            Uri.parse('${MyUrls.apiUrl}store_insert'),
            headers: MyUrls.postHeadersList,
          body: jsonEncode(
                {"phone": MyUrls.userPhone, "password": MyUrls.userPassword, "product":productIds}),
          ).timeout(MyUrls.timesOutInSeconds);

          print("i am in DargsController in fetch function ,${response.body}");
          if (response.statusCode == 201) {
            // final data = utf8.decode(response.bodyBytes);
            final element = response.body;
            print(element);

            if(Get.isDialogOpen==true)
            {
              Get.back();
            }
            return true;
          }
          else {
            // final element = jsonDecode(response.body);
            print(response.body);
            if(Get.isDialogOpen==true)
            {
              Get.back();
            }
            CustomDialog.showImageAlertDialog(
                title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
                img: "images/no-wifi.png", //successful dialog image
                buttonText: "حاول مجددا",
                onPressed: () {
                  addToCart();
                  Get.back();
                }
            );
            // Get.dialog(
            //     Dialog(
            //       child: Text(element.toString()),
            //     )
            // );

            return false;
          }
        } on TimeoutException catch(e)
        {
          if(Get.isDialogOpen==true)
          {
            Get.back();
          }
          // update();
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"استغرق الأمر أكثر من اللازم، تأكد من جودة الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              buttonText: "حاول مجددا",
              onPressed: () {
                addToCart();
                Get.back();
              }
          );
          return false;
        } on SocketException catch (e) {
          if(Get.isDialogOpen==true)
          {
            Get.back();
          }
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              buttonText: "حاول مجددا",
              onPressed: () {
                addToCart();
                Get.back();
              }
          );
          // Get.dialog(
          //     Dialog(
          //       child: Text("Socket Error:$e"),
          //     )
          // );
          return false;

        }  catch (e) {
          if(Get.isDialogOpen==true)
          {
            Get.back();
          }
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              buttonText: "حاول مجددا",
              onPressed: () {
                addToCart();
                Get.back();
              }
          );
          // Get.dialog(
          //     Dialog(
          //       child: Text("Error:$e"),
          //     )
          // );
          return false;
        }
      }
    return false;
  }
  @override
  void onInit() {
    fetch();
    super.onInit();
  }
}