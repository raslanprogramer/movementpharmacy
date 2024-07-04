import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../static/my_urls.dart';
import '../../views/widgets/MyText.dart';
import '../../views/widgets/custom_dialog.dart';
class PurchaseController extends GetxController
{
  String? totalPrice;
  betweenToDatesRequest(String? firstDate,String? lastDate)
  async {
    if(firstDate!=null && lastDate!=null)
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

        try
            {final response = await http.post(
              Uri.parse('${MyUrls.apiUrl}adminpanel/getpayments'),
              headers:MyUrls.postHeadersList,
              body: jsonEncode(
                  {"phone": MyUrls.adminControllerPhone, "password": MyUrls.adminPassword,
                    "firstDate":firstDate,
                    "lastDate":lastDate,
                    "country":MyUrls.adminCountry}),
            );
            print("i am in BillController in fetch function ,${response.statusCode.toString()}");
            if (response.statusCode == 200) {
              getBack();
              // final data = utf8.decode(response.bodyBytes);
              final element = jsonDecode(response.body);
              print(element);
              if(element['total_price']!=null && element['total_price']!='null')
                {
                  totalPrice=element['total_price'].toString();
                }
              else
                {
                  totalPrice='0.0';
                }
              update();/////////////
            }
            else {
              getBack();
              final element = jsonDecode(response.body);
              CustomDialog.showImageAlertDialog(
                  title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}",size: 15,),),
                  img: "images/error_message.jpg", //successful dialog image
                  buttonText: "حاول مجددا",
                  onPressed: () {
                    Get.back();
                  }
              );
              totalPrice=null;
              update();/////////////
            }
            }
        on SocketException catch (e) {
          getBack();
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              buttonText: "حاول مجددا",
              onPressed: () {
                betweenToDatesRequest(firstDate, lastDate);
                Get.back();
              }
          );
          totalPrice=null;
          update();/////////////

        }  catch (e) {
          getBack();
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              buttonText: "حاول مجددا",
              onPressed: () {
                betweenToDatesRequest(firstDate, lastDate);
                Get.back();
              }
          );
          totalPrice=null;
          update();/////////////
        }
      }
  }
  getBack()
  {
    if(Get.isDialogOpen==true)
    {
      Get.back();
    }
  }
}