import 'package:get/get.dart';

import '../../models/admin_models/customer.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movementfarmacy/models/product.dart';
import 'package:movementfarmacy/static/my_urls.dart';

import '../../views/widgets/MyText.dart';
import '../../views/widgets/custom_dialog.dart';

class CustomersController extends GetxController
{
  List<Customer> customers=[];
  bool isLoad=false;
  bool connectionError=false;

  Future fetch()async
  {
    connectionError=false;
    if(isLoad==false)
    {
      isLoad=true;
      update();
      try {

        final response = await http.post(
          Uri.parse('${MyUrls.apiUrl}adminpanel/getstores'),
          headers: MyUrls.postHeadersList,
          body: jsonEncode(
              {"phone": MyUrls.adminControllerPhone,"password": MyUrls.adminPassword,"country":MyUrls.adminCountry}),
        ).timeout(MyUrls.timesOutInSeconds);
        print(response.statusCode.toString());
        if (response.statusCode == 200) {
          // final data = utf8.decode(response.bodyBytes);
          final element =jsonDecode(response.body);
          print("i am in CartController in fetch function ,response body is${element}");
          for(var elem in element['data'])
          {
            customers.add(Customer.fromJson(elem));
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
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
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
  updateStoreData(Customer customer)async
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

    try {
      final response = await http.post(
        Uri.parse('${MyUrls.apiUrl}adminpanel/updatestore'),
        headers: MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": MyUrls.adminControllerPhone,"password": MyUrls.adminPassword,"country":MyUrls.adminCountry,
            "store_id":customer.id,"store_name":customer.name,"store_phone":customer.phone,"store_password":customer.password,
            "store_location":customer.location,"store_note":customer.note,"store_country":customer.country}),
      ).timeout(MyUrls.timesOutInSeconds);
      if (response.statusCode == 201) {
        getBack();//to close dialog
        getBack();//to close dialog
        final element =jsonDecode(response.body);
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: const EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}",size: 15,),),
            img: "images/tick.png", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );
        customers.clear();
        fetch();
      }
      else {
        getBack();
        final element =jsonDecode(response.body);
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: const EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}",size: 15,),),
            img: "images/error_message.png", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );

      }
    }on TimeoutException catch(e)
    {
      getBack();
      CustomDialog.showImageAlertDialog(
          title:Padding(padding: const EdgeInsets.only(top: 10),child: MyText(txt:"${"تحقق من اتصال الانترنت"}",size: 15,),),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
    }on SocketException catch (e) {
      getBack();
      CustomDialog.showImageAlertDialog(
          title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
      print("i am in socket execption isLoad=${isLoad}");
    } catch (e) {
      getBack();
      CustomDialog.showImageAlertDialog(
          title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
    }
  }
  deleteCustomer(int storeId)
  async {

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
        try {
          // final response = await http.get(
          //   Uri.parse('${MyUrls.apiUrl}store/1/cart'),
          //   // body: jsonEncode(
          //   //     {'phone': "713754340", 'password': "0220"}),
          // );
          final response = await http.post(
            Uri.parse('${MyUrls.apiUrl}admin/deletestore'),
            headers: MyUrls.postHeadersList,
            body: jsonEncode(
                {"phone": MyUrls.adminControllerPhone,"password": MyUrls.adminPassword,"country":MyUrls.adminCountry,
                  "store_id":storeId.toString()}),
          ).timeout(MyUrls.timesOutInSeconds);
          print(response.body);
          if (response.statusCode == 201) {
            getBack();//to close dialog
            final element =jsonDecode(response.body);
            CustomDialog.showImageAlertDialog(
                title:Padding(padding: const EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}",size: 15,),),
                img: "images/tick.png", //successful dialog image
                onPressed: () {
                  Get.back();
                }
            );
            customers.clear();
            fetch();
          }
          else {
            getBack();
            final element =jsonDecode(response.body);
            CustomDialog.showImageAlertDialog(
                title:Padding(padding: const EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}",size: 15,),),
                img: "images/error_message.jpg", //successful dialog image
                onPressed: () {
                  Get.back();
                }
            );

          }
        }on TimeoutException catch(e)
        {
          getBack();
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: const EdgeInsets.only(top: 10),child: MyText(txt:"${"تحقق من اتصال الانترنت"}",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              onPressed: () {
                Get.back();
              }
          );
        }on SocketException catch (e) {
          getBack();
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              onPressed: () {
                Get.back();
              }
          );
        } catch (e) {
          getBack();
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              onPressed: () {
                Get.back();
              }
          );
        }

  }
  getBack()
  {
    if(Get.isDialogOpen==true)
      {
        Get.back();
      }
  }
  @override
  void onInit() {
    fetch();
    super.onInit();
  }

}