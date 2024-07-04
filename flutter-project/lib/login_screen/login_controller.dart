import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movementfarmacy/main.dart';
import 'package:movementfarmacy/views/widgets/MyText.dart';
import '../../../static/my_urls.dart';
import '../static/helper_fuctions.dart';
import '../views/widgets/custom_dialog.dart';
import 'location_setting.dart';
class LoginController extends GetxController
{
  String name="";
  String phone="";
  String password="";
  Future<bool> login()async
  {
    Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        child: Dialog(
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
      ),
    );
    String location=prefs?.getString("location")??"null";
    // String? token=await FirebaseMessaging.instance.getToken();
    int country=prefs?.getInt("country")??0;
    // print( jsonEncode(
    //     {"name":name,"phone": phone, "password": password, "location":location,"note":"","country":country}));
    try {
      final response = await http.post(
        Uri.parse('${MyUrls.apiUrl}store?name=$name&password=$password&phone=$phone&location=$location&country=$country'),
        headers:MyUrls.postHeadersList,
        body:jsonEncode(
            {"name":name,"phone":phone, "password": password,
              "location":location,"note":"","country":country}),
      ).timeout(MyUrls.timesOutInSeconds);
      print("i am in LoginController in login function ,${response.statusCode.toString()}");
      if (response.statusCode == 201) {
        // final data = utf8.decode(response.bodyBytes);
        final element = jsonDecode(response.body);
        print(element);
        prefs?.setString("phone", phone);
        prefs?.setString("password", password);
        if(element['admin_phone']!=null && element['admin_phone']!='') {
          prefs?.setString("adminPhone", element['admin_phone']);
          MyUrls.adminPhone=element['admin_phone'];
        }
        MyUrls.userPassword=password;
        MyUrls.userPhone=phone;
        if(Get.isDialogOpen==true)
          {
            Get.back();
          }
        return true;
      }
      else if(response.statusCode == 406)
        {
          if(Get.isDialogOpen==true)
          {
            Get.back();
          }
          print(response.body);
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"قم بتعبئة الحقول بالشكل الصحيح",size: 15,),),
              img: "images/error_message.jpg", //successful dialog image
              // inkWell: TextButton(onPressed: (){ Get.back();
              // }, child: Text("رجوع")),
              onPressed: () {
                Get.back();
              }
          );

          return false;
        }
      else if(response.statusCode == 305)
      {
        if(Get.isDialogOpen==true)
        {
          Get.back();
        }
        CustomDialog.showImageAlertDialog(
            title:Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"هذا الحساب موجود بالفعل ،اضغط على الزر لدي حساب؟ اسفل الشاشة ",size: 14,),),
                InkWell(child: Padding(padding: EdgeInsets.only(top: 10,bottom: 10),child: MyText(txt:"او اتصل بخدمة العملاء",size: 14,color: Colors.blue,textDecoration: TextDecoration.underline,),),
                   onTap: (){
                    HelperFunctions.makePhoneCall("713683090");
                   }, )
              ],
            ),
            img: "images/error_message.jpg", //successful dialog image
            // inkWell: TextButton(onPressed: (){ Get.back();
            // }, child: Text("رجوع")),
            onPressed: () {
              Get.back();
            }
        );
        return false;
      }
      else {
        if(Get.isDialogOpen==true)
        {
          Get.back();
        }
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );
        return false;
      }
    } on SocketException catch (e) {
      if(Get.isDialogOpen==true)
      {
        Get.back();
      }
      CustomDialog.showImageAlertDialog(
          title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
      // Get.dialog(
      //     Dialog(
      //       child: Text("Socket Error:$e"),
      //     )
      // );
      return false;
    } catch (e) {
      if(Get.isDialogOpen==true)
      {
        Get.back();
      }
      CustomDialog.showImageAlertDialog(
          title:Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصالك بالانترنت",size: 14,),),
              InkWell(child: Padding(padding: EdgeInsets.only(top: 10,bottom: 10),child: MyText(txt:"او اتصل بخدمة العملاء",size: 14,color: Colors.blue,textDecoration: TextDecoration.underline,),),
                onTap: (){
                  HelperFunctions.makePhoneCall("713683090");
                }, )
            ],
          ),
          img: "images/error_message.jpg", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
      return false;
    }
  }
  Future<bool> hasAcount()async
  {
    // print( jsonEncode(
    //     {"phone": phone, "password": password}));

    try {
      // String? token=await FirebaseMessaging.instance.getToken();
      final response = await http.post(
        Uri.parse('${MyUrls.apiUrl}hasacount'),
        headers: MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": phone, "password": password}),
      );
      print("i am in AdvertisementController in fetch function ,${response.statusCode.toString()}");
      if (response.statusCode == 200) {
        // final data = utf8.decode(response.bodyBytes);
        final element = jsonDecode(response.body);
        print(element);
        prefs?.setString("phone", element['data']['phone']);
        prefs?.setString("password",  element['data']['password']);
        prefs?.setInt("country",  element['data']['country']);
        MyUrls.userPassword=password;
        MyUrls.userPhone=phone;
        return true;
      }else if(response.statusCode==406)
        {
          CustomDialog.showImageAlertDialog(
              title:Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"خطأ في كلمة السر",size: 14,),),
                  InkWell(child: Padding(padding: EdgeInsets.only(top: 10,bottom: 10),child: MyText(txt:"نسيت كلمة السر ،الاتصال بخدمة العملاء",size: 14,color: Colors.blue,textDecoration: TextDecoration.underline,),),
                    onTap: (){
                      HelperFunctions.makePhoneCall("713683090");
                    }, )
                ],
              ),
              img: "images/error_message.jpg", //successful dialog image
              // inkWell: TextButton(onPressed: (){ Get.back();
              // }, child: Text("رجوع")),
              onPressed: () {
                Get.back();
              }
          );
          return false;
        }
      else if(response.statusCode==405)
        {
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"رقم الهاتف غير مسجلا",size: 15,),),
              img: "images/error_message.jpg", //successful dialog image
              // inkWell: TextButton(onPressed: (){ Get.back();
              // }, child: Text("رجوع")),
              onPressed: () {
                Get.back();
              }
          );
          return false;

        }
      else if(response.statusCode==401)
        {
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"قم باخال البيانات بالشكل الصحيح",size: 15,),),
              img: "images/error_message.jpg", //successful dialog image
              // inkWell: TextButton(onPressed: (){ Get.back();
              // }, child: Text("رجوع")),
              onPressed: () {
                Get.back();
              }
          );
          return false;
        }
      else {
        final element = jsonDecode(response.body);
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );
        return false;
      }
    } on SocketException catch (e) {
      CustomDialog.showImageAlertDialog(
          title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
      return false;
    } catch (e) {
      CustomDialog.showImageAlertDialog(
          title:Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصالك بالانترنت",size: 14,),),
              InkWell(child: Padding(padding: EdgeInsets.only(top: 10,bottom: 10),child: MyText(txt:"او اتصل بخدمة العملاء",size: 14,color: Colors.blue,textDecoration: TextDecoration.underline,),),
                onTap: (){
                  HelperFunctions.makePhoneCall("713683090");
                }, )
            ],
          ),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
      return false;
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

}