
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movementfarmacy/models/bill.dart';
import '../../static/my_urls.dart';
import '../widgets/MyText.dart';
import '../widgets/custom_dialog.dart';
class PaymentController extends GetxController
{
  List<Bill> bills=[];
  int currentPage=1;
  int lastPage=1;
  int status=0;//الفاوتير التي لم يام الموفقة عليها بعد
  bool isLoad=true;
  bool startPagnition=false;
  bool connectionError=false;
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
              Uri.parse('${MyUrls.apiUrl}bill/select?phone=${ MyUrls.userPhone}&password=${MyUrls.userPassword}&status=$status&page=$currentPage'),
              headers: MyUrls.postHeadersList,
              body: jsonEncode(
                  {"phone": MyUrls.userPhone, "password": MyUrls.userPassword, "status":status}),
            ).timeout(MyUrls.timesOutInSeconds);
            print("i am in BillController in fetch function ,${response.statusCode.toString()}");
            if (response.statusCode == 200) {
              // final data = utf8.decode(response.bodyBytes);
              final element = jsonDecode(response.body);
              print(element);
              if (element['data']['data'] != null && (element['data']['data'] as List).isNotEmpty) {
                for (var bill in element['data']['data']) {
                  bills.add(Bill.fromJson(bill));
                }
                lastPage=element['data']['last_page'];
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
              startPagnition=false;
               connectionError=true;

              update();/////////////
            }
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
            startPagnition=false;
            connectionError=true;

            update();/////////////

          } on Error catch (e) {
            isLoad=false;
            connectionError=true;
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
  //لتحميل الفواتير التي تم الموافقة عليها
  void changeStatus({required int status})
  {
    this.status=status;
    currentPage=lastPage=1;
    isLoad=true;
    bills.clear();
    startPagnition=false;
    fetch();
  }
  @override
  void onInit() {
    fetch();
    super.onInit();
  }
}
