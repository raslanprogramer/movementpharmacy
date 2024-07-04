import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movementfarmacy/models/admin_models/admin_bill.dart';
import '../../static/my_urls.dart';
import '../../views/widgets/MyText.dart';
import '../../views/widgets/custom_dialog.dart';
class NewOrderController extends GetxController
{
  NewOrderController({required this.status});
  final int status;//هناك حالتين في حالة الطلبات الجديدة والتي عبرنا عنها بالقيمة صفر والحالة الأخرى قيد التوصيل والتي عبرنا عنها بالقيمة 1
  List<AdminBill> bills=[];
  int currentPage=1;
  int lastPage=1;
  bool isLoad=true;
  bool startPagnition=false;
  bool connectionError=false;
  String currentRoute=Get.currentRoute.toString();
  Future fetch()async
  {
    print(MyUrls.userPhone.toString());
    if(currentPage<=lastPage) {
      try {
        isLoad=true;
        if(currentPage>1)
        {
          startPagnition=true;
        }
        final response = await http.post(
          Uri.parse('${MyUrls.apiUrl}adminpanel/getallbills?phone=${MyUrls.adminControllerPhone}&password=${MyUrls.adminPassword}&status=${status}&country=${MyUrls.adminCountry}&page=$currentPage'),
          headers: MyUrls.postHeadersList,
          body: jsonEncode(
              {"phone": MyUrls.adminControllerPhone,
                "password": MyUrls.adminPassword,
                "status":status,
              "country":MyUrls.adminCountry}),
        ).timeout(MyUrls.timesOutInSeconds);
        print("i am in BillController in fetch function ,${response.statusCode.toString()}");
        if (response.statusCode == 200) {
          // final data = utf8.decode(response.bodyBytes);
          final element = jsonDecode(response.body);
          print(element);
          if (element['data'] != null && (element['data'] as List).isNotEmpty) {
            for (var bill in element['data']) {
              bills.add(AdminBill.fromJson(bill));
            }
            lastPage=element['last_page'];
          }
          currentPage++;
          isLoad=false;
          startPagnition=false;
          connectionError=false;
          update();/////////////
        }
        else {
          isLoad=false;
          bool connectionError=true;
          print(Get.currentRoute);
          if(Get.currentRoute==currentRoute)
        {
          final element = jsonDecode(response.body);
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              buttonText: "حاول مجددا",
              onPressed: () {
                fetch();
                Get.back();
              }
          );
          isLoad=false;
          startPagnition=false;
          connectionError=true;

          update();/////////////
        }
        }
      }
      on SocketException catch (e) {
        isLoad=false;
        print(Get.currentRoute);
        if(Get.currentRoute==currentRoute)
          {
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
            startPagnition=false;
            connectionError=true;

            update();/////////////
          }


      }on TimeoutException catch (e) {
        isLoad=false;
        connectionError=true;

        if(Get.currentRoute==currentRoute)
          {
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
            startPagnition=false;
            connectionError=true;
            update();/////////////
          }
      }catch (e) {
        isLoad=false;
        connectionError=true;
        if(Get.currentRoute==currentRoute)
        {
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
          startPagnition=false;
          connectionError=true;
          update();/////////////
        }

      }
    }

  }
  //لتحميل الفواتير التي تم الموافقة عليها
  // void changeStatus({required int status})
  // {
  //   this.status=status;
  //   currentPage=lastPage=1;
  //   isLoad=true;
  //   bills.clear();
  //   startPagnition=false;
  //   update();
  //   fetch();
  // }

  updateBill(String? billNumber)async
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
        Uri.parse('${MyUrls.apiUrl}adminpanel/updatebills?phone=${MyUrls.adminControllerPhone}&password=${MyUrls.adminPassword}&status=${status==0?1:2}&country=${MyUrls.adminCountry}&bill_id=${billNumber}'),
        headers: MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": MyUrls.adminControllerPhone,
              "password": MyUrls.adminPassword,
              "status":status==0?1:2,//في حالة كانت الفاتورة تحت الطلب والتي عبرنا عنها بالحالة صفر نحولها الى واحد والتي تعني قيد التوصيل وشبه ذلك للحالة واحد نحولها الى اثنين
              "country":MyUrls.adminCountry,
            "bill_id":billNumber}),
      ).timeout(MyUrls.timesOutInSeconds);
      print("i am in BillController in fetch function ,${response.statusCode.toString()}");
      if (response.statusCode == 201) {
        getBack();
        // final data = utf8.decode(response.bodyBytes);
        final element = jsonDecode(response.body);
        bills.clear();
        currentPage=lastPage=1;
        fetch();
        update();
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تم ترحيل الطلب رقم ${billNumber} بنجاح",size: 15,),),
            img: "images/tick.png", //successful dialog image
            buttonText: "رجوع",
            onPressed: () {
              Get.back();
            }
        );
      }
      else {
        isLoad=false;
        bool connectionError=true;
        print(Get.currentRoute);
        if(Get.currentRoute==currentRoute)
        {
          getBack();
          final element = jsonDecode(response.body);
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}",size: 15,),),
              img: "images/error_message.jpg", //successful dialog image
              buttonText: "رجوع",
              onPressed: () {
                Get.back();
              }
          );
        }
      }
    }
    on SocketException catch (e) {


      if(Get.currentRoute==currentRoute)
      {
        getBack();
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            buttonText: "حاول مجددا",
            onPressed: () {
              updateBill(billNumber);

              Get.back();
            }
        );

      }


    }on TimeoutException catch (e) {

      if(Get.currentRoute==currentRoute)
      {
        getBack();
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            buttonText: "حاول مجددا",
            onPressed: () {
              updateBill(billNumber);

              Get.back();
            }
        );

      }
    }on Error catch (e) {

      if(Get.currentRoute==currentRoute)
      {
        getBack();
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            buttonText: "حاول مجددا",
            onPressed: () {
              updateBill(billNumber);
              Get.back();
            }
        );

      }

    }
  }
  cancelBill(String? billNumber)async
  {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(50.0))),
        insetPadding: EdgeInsets.symmetric(horizontal: Get.width/2-30),
        child: const SizedBox(
          height: 60,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: CircularProgressIndicator(color: Colors.green,),
          ),
        ),
      ),
    );
    try {
      final response = await http.post(
        Uri.parse('${MyUrls.apiUrl}adminpanel/deletebills?phone=${MyUrls.adminControllerPhone}&password=${MyUrls.adminPassword}&country=${MyUrls.adminCountry}&bill_id=${billNumber}'),
        headers: MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": MyUrls.adminControllerPhone,
              "password": MyUrls.adminPassword,
              "country":MyUrls.adminCountry,
              "bill_id":billNumber}),
      ).timeout(MyUrls.timesOutInSeconds);
      print("i am in BillController in fetch function ,${response.statusCode.toString()}");
      if (response.statusCode == 201) {
        getBack();
        bills.clear();
        currentPage=lastPage=1;
        fetch();
        update();
        // final data = utf8.decode(response.bodyBytes);
        final element = jsonDecode(response.body);
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تم الغاء الطلب رقم ${billNumber} بنجاح",size: 15,),),
            img: "images/tick.png", //successful dialog image
            buttonText: 'رجوع',
            onPressed: () {
              Get.back();
            }
        );

      }
      else {
        isLoad=false;
        bool connectionError=true;
        print(Get.currentRoute);
        if(Get.currentRoute==currentRoute)
        {
          getBack();
          final element = jsonDecode(response.body);
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}",size: 15,),),
              img: "images/error_message.jpg", //successful dialog image
              buttonText: "رجوع",
              onPressed: () {
                Get.back();
              }
          );
        }
      }
    }
    on SocketException catch (e) {


      if(Get.currentRoute==currentRoute)
      {
        getBack();
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            buttonText: "حاول مجددا",
            onPressed: () {
              updateBill(billNumber);

              Get.back();
            }
        );

      }


    }on TimeoutException catch (e) {

      if(Get.currentRoute==currentRoute)
      {
        getBack();
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            buttonText: "حاول مجددا",
            onPressed: () {
              updateBill(billNumber);

              Get.back();
            }
        );

      }
    }on Error catch (e) {

      if(Get.currentRoute==currentRoute)
      {
        getBack();
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            buttonText: "حاول مجددا",
            onPressed: () {
              updateBill(billNumber);
              Get.back();
            }
        );

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
  @override
  void onInit() {
    fetch();
    super.onInit();
  }
}
