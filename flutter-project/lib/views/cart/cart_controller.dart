import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movementfarmacy/models/product.dart';
import 'package:movementfarmacy/static/my_urls.dart';
import 'package:get/get.dart';

import '../../static/helper_fuctions.dart';
import '../widgets/MyText.dart';
import '../widgets/custom_dialog.dart';
class CartController extends GetxController{
  //خاص بالمنتجات فقط
  List<Product> products = [];
  List<int> mounts=[];//الكميات التي في السلة لكل منتج
  double totalPrice=0;
  bool isLoad=false;
  bool connectionError=false;
  Future fetch() async
  {
    connectionError=false;
    totalPrice=0;
    if(isLoad==false)
      {
        isLoad=true;
        update();
        try {

          final response = await http.post(
            Uri.parse('${MyUrls.apiUrl}store_get'),
            headers:MyUrls.postHeadersList,
            body: jsonEncode(
                {"phone": MyUrls.userPhone,"password": MyUrls.userPassword}),
          ).timeout(MyUrls.timesOutInSeconds);
          print(response.statusCode.toString());
          if (response.statusCode == 200) {
            // final data = utf8.decode(response.bodyBytes);
            final element =jsonDecode(response.body);
            print("i am in CartController in fetch function ,response body is${element}");
            for(var elem in element['data'])
            {
              Product product=Product.fromJson(elem['product']);
              products.add(product);
              totalPrice+=product.price!;
              mounts.add(elem['amount']);
            }
            isLoad=false;
            connectionError=false;
            update();
          }
          else {
            print("i am in CartController in delete function ,response body is${response.body}");
            final element = jsonDecode(response.body);
            CustomDialog.showImageAlertDialog(
                title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}تأكد من اتصال الانترنت",size: 15,),),
                img: "images/no-wifi.png", //successful dialog image
                onPressed: () {
                  Get.back();
                }
            );
            connectionError=true;
            isLoad=false;
            update();
          }
        }on TimeoutException catch(e)
        {
          print("i am in socket TimeoutException isLoad=${isLoad}");
          isLoad=false;
          connectionError=true;
          update();
        }on SocketException catch (e) {
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              onPressed: () {
                Get.back();
              }
          );
          isLoad=false;
          connectionError=true;
          print("i am in socket execption isLoad=${isLoad}");
          update();
        } catch (e) {
          CustomDialog.showImageAlertDialog(
              title:Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصالك بالانترنت",size: 14,),),
                  InkWell(child: Padding(padding: EdgeInsets.only(top: 10,bottom: 10),child: MyText(txt:"او اتصل بخدمة العملاء",size: 14,color: Colors.blue,textDecoration: TextDecoration.underline,),),
                    onTap: (){
                      HelperFunctions.makePhoneCall("713754340");
                    }, )
                ],
              ),
              img: "images/no-wifi.png", //successful dialog image
              onPressed: () {
                Get.back();
              }
          );
          isLoad=false;
          connectionError=true;
          update();
        }
      }

  }
  bool waitDelete=false;
  Future<bool> delete(int index,int id)async
  {
    if(!waitDelete)
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
        waitDelete=true;
        update();
        try {
          final response = await http.post(
            Uri.parse('${MyUrls.apiUrl}store_delete'),
            headers: MyUrls.postHeadersList,
            body: jsonEncode(
                {"phone": MyUrls.userPhone, "password": MyUrls.userPassword, "product":id}),
          ).timeout(MyUrls.timesOutInSeconds);
          print(response.statusCode.toString());
          if (response.statusCode == 201) {
            // final data = utf8.decode(response.bodyBytes);
            final element = jsonDecode(response.body);
            print("i am in CartController in delete function ,response body id$element");

            products.removeAt(index);
            mounts.removeAt(index);
            totalPrice=0;
            for(int i=0;i<products.length;i++)
            {
              totalPrice+=products[i].price!*mounts[i];
            }
            waitDelete=false;
            if(Get.isDialogOpen!=null && Get.isDialogOpen==true)
            {
              Get.back();
            }
            update();
            return true;
          }
          else {
            final element = jsonDecode(response.body);
            print(response.body.toString());
            CustomDialog.showImageAlertDialog(
                title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}تأكد من اتصال الانترنت",size: 15,),),
                img: "images/no-wifi.png", //successful dialog image
                onPressed: () {
                  Get.back();
                }
            );
            waitDelete=false;
            if(Get.isDialogOpen!=null && Get.isDialogOpen==true)
            {
              Get.back();
            }
            update();
            return false;
          }
        }on TimeoutException catch(e)
        {
          waitDelete=false;
          if(Get.isDialogOpen!=null && Get.isDialogOpen==true)
          {
            Get.back();
          }
          update();
          return false;
        } on SocketException catch (e) {
          CustomDialog.showImageAlertDialog(
              title: Text( "ليس هناك اتصال بالانترنت",),
              img: "images/no-wifi.png", //successful dialog image
              onPressed: () {
                Get.back();
              }

          );
          waitDelete=false;
          if(Get.isDialogOpen!=null && Get.isDialogOpen==true)
          {
            Get.back();
          }
          update();
          return false;
        } catch (e) {
          waitDelete=false;
          if(Get.isDialogOpen!=null && Get.isDialogOpen==true)
          {
            Get.back();
          }
          print("Error:$e");
          CustomDialog.showImageAlertDialog(
              title: Text( "ليس هناك اتصال بالانترنت",),
              img: "images/no-wifi.png", //successful dialog image
              onPressed: () {
                Get.back();
              }
          );
          update();
          return false;
        }
      }
    else
      {
        return false;
      }

  }
  encrement(int index)
  {
    mounts[index] =
    (mounts[index] +1);
    totalPrice= totalPrice + (products[index].price!);
    update();
  }
  decrement(int index)
  {

      mounts[index] =
      (mounts[index] -1);
      totalPrice= totalPrice - (products[index].price!);
      update();
  }

  Future<bool> addOrder()async
  {

    try {
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(50.0))),
          insetPadding: EdgeInsets.symmetric(
              horizontal: Get.width / 2 - 30),
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                color: Colors.green,),
            ),
          ),
        ),
      );

      List<Map<String,dynamic>> sendProducts=[];
      for(int i=0;i<products.length;i++)
        {
          sendProducts.add({
            "id":products[i].id,
            "quantity":mounts[i]
          });
        }
      final response = await http.post(
        Uri.parse('${MyUrls.apiUrl}bill'),
        headers:MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": MyUrls.userPhone,"password": MyUrls.userPassword,"products":sendProducts}),
      ).timeout(MyUrls.timesOutInSeconds);
      print("i am in BillController in fetch function ,${response.statusCode.toString()}");


      print(response.body);
      // final element = jsonDecode(response.body);
      if (response.statusCode == 201) {
        // final data = utf8.decode(response.bodyBytes);
        // final element = jsonDecode(response.body);
        print(response.body);
        totalPrice=0;
        products.clear();
        mounts.clear();
        Get.back();
        update();
        return true;
      }
      else {
        Get.back();
        // isLoad=false;
        CustomDialog.showImageAlertDialog(
            title: Text( "ليس هناك اتصال بالانترنت",),
            img: "images/no-wifi.png", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );
        // update();
        return false;
      }
    }on TimeoutException catch(e)
    {
      Get.back();
      print("i am in socket TimeoutException isLoad=${isLoad}");
      // update();
      return false;
    }
    on SocketException catch (e) {
      Get.back();
      CustomDialog.showImageAlertDialog(
          title: Text( "ليس هناك اتصال بالانترنت",),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
      // update();
      return false;


    }  catch (e) {
      Get.back();
      // isLoad=false;
      CustomDialog.showImageAlertDialog(
          title: Text( "ليس هناك اتصال بالانترنت",),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
      // update();
      return false;
    }
  }
  Future<bool> dropAllItems()async
  {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(50.0))),
        insetPadding: EdgeInsets.symmetric(
            horizontal: Get.width / 2 - 30),
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircularProgressIndicator(
              color: Colors.green,),
          ),
        ),
      ),
    );
   try
       {
         final response = await http.post(
           Uri.parse('${MyUrls.apiUrl}store_delete_all'),
           headers:MyUrls.postHeadersList,
           body: jsonEncode(
               {"phone": MyUrls.userPhone,"password": MyUrls.userPassword}),
         );
         if (response.statusCode == 201) {
           // final data = utf8.decode(response.bodyBytes);
           final element = jsonDecode(response.body);
           totalPrice=0;
           products.clear();
           mounts.clear();
           if(Get.isDialogOpen==true)
             {
               Get.back();
             }
           update();
           return true;
         }
         else
         {
           if(Get.isDialogOpen==true)
           {
             Get.back();
           }
           return false;
         }
       }

       catch(e)
    {
      if(Get.isDialogOpen==true)
      {
        Get.back();
      }
      return false;
    }
  }
  @override
  void onInit() {
    fetch();
    super.onInit();
  }
}