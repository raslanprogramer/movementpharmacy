import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movementfarmacy/main.dart';
import 'package:movementfarmacy/theme/AppColor.dart';

import '../static/my_urls.dart';
import '../views/widgets/MyText.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../views/widgets/custom_dialog.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  var items = [
    'اليمن',
    'السعودية'
  ];
  late String dropdownvalue ;
  GlobalKey<FormState> formKey=GlobalKey<FormState>();
  TextEditingController name=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController password=TextEditingController();

@override
  void initState() {
    // TODO: implement initState
  dropdownvalue=items[0];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor:AppColors.primaryGreen,
        shadowColor: null,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.arrow_back_ios_new, color: Colors.white,)),
            ),
            Expanded(child:
            Center(
              child: MyText(
                txt: "تسجيل الدخول",
                color: Colors.white,
              ),
              // child: Text("الأدوية",
              //   style: TextStyle(color:
              //   Colors.white.withOpacity(.7),
              //   fontFamily:'Black.otf' ),)

            )),
            InkWell(
                onTap: () {

                },
                splashColor: Colors.grey.withOpacity(.5),
                child: Container(
                  // alignment: Alignment.center,
                    width: 40,
                    height: 40,
                  // child: MyText(txt: "تفريغ",size: 16,color: Colors.white,),
                ))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key:formKey ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: phone,
                  maxLines: 2,
                  minLines: 1,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      filled: true,
                      hintText: "رقم الهاتف",

                      prefixIcon: Icon(Icons.phone,color: Colors.green.shade700,),
                      fillColor: Colors.green.shade50,
                      // border: OutlineInputBorder(
                      //
                      //   borderRadius: BorderRadius.circular(10),
                      //   borderSide: BorderSide.none,
                      // )
                  ),
                ),

              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: password,
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "كلمة السر",
                    prefixIcon: Icon(Icons.lock,color: Colors.green.shade700,),
                    fillColor: Colors.green.shade50,
                    // border: OutlineInputBorder(
                    //
                    //   borderRadius: BorderRadius.circular(10),
                    //   borderSide: BorderSide.none,
                    // )
                  ),
                ),

              ),
             SizedBox(height: 20,),
             Padding(
               padding: EdgeInsets.symmetric(horizontal: 20),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   MyText(txt: "الدولة: ",size: 15,),
                   SizedBox(width: 10,),
                   DropdownButton(
                     // dropdownColor:AppColors.primaryMainGreen,
                     // underline: Divider(color: Colors.white,),
                     value: dropdownvalue,
                     alignment: Alignment.bottomRight,
                     icon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                     items: items.map((String items) {
                       return DropdownMenuItem(
                         alignment: Alignment.centerRight,
                         value: items,
                         child: MyText(txt:items,size: 15,color:Colors.black,),
                       );
                     }).toList(),
                     onChanged: (String? newValue) {
                       if(newValue!=dropdownvalue)
                       {
                         setState(() {
                           dropdownvalue = newValue!;
                         });
                       }
                     },
                   ),
                 ],
               ),
             ),

              SizedBox(height: 20,),
              Container(
                  width: 200,
                  color: AppColors.primaryGreen,
                  child: ElevatedButton(onPressed: (){
                    register();
                  }, child: MyText(txt: "انطلاق",)))
            ],
          ),
        ),
      ),
    );
  }
  register()async
  {
    String? token=await FirebaseMessaging.instance.getToken();
    print(token);


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
        Uri.parse('${MyUrls.apiUrl}adminpanel/registeremploy?phone=${phone.text}&password=${password.text}&country=${dropdownvalue==items[0]?"0":"1"}&token=$token'),
        headers: MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": phone.text,
              "password": password.text,
              "country":dropdownvalue==items[0]?"0":"1",
            "token":token}),
      ).timeout(MyUrls.timesOutInSeconds);
      print("i am in BillController in fetch function ,${response.statusCode.toString()}");
      if (response.statusCode == 200) {
        getBack();
        print(response.body);
        // final data = utf8.decode(response.bodyBytes);
        final element = jsonDecode(response.body);
       prefs?.setString("adminpassword", password.text);
        prefs?.setString("admin_contrller_phone", phone.text);
        if(element['position']=="admin")
          {
            prefs?.setString("admin_country",dropdownvalue==items[0]?'0':'1');
          }
        else
          {
            prefs?.setString("admin_country", element['country'].toString());
            if(element['position']=="delivery")
              {
                //
                if(element['country']==0)
                  {
                    //اشراك جميع الموصلين في البلد بنفس الاشعار
                    await FirebaseMessaging.instance.subscribeToTopic('yemeni_delivery');
                  }
                else if(element['country']==1)
                  {
                    await FirebaseMessaging.instance.subscribeToTopic('saudi_delivery');
                  }
              }
          }
        prefs?.setString("admin_token",element['token']);
        prefs?.setString("admin_position", element['position'].toString());

        MyUrls.adminCountry=int.tryParse(prefs!.getString("admin_country").toString())??0;
        MyUrls.adminPosition=prefs!.getString("admin_position").toString()??"";
        MyUrls.adminControllerPhone=prefs!.getString("admin_contrller_phone").toString()??"";
        MyUrls.adminPassword=prefs!.getString("adminpassword").toString()??"";


        Get.back();

        // print("goooooooo${prefs?.getString("admin_position")}")!!!!;
      }
      else {
        print("llllllllllllllllllllllllll");
        print(response.body);
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
    }on SocketException catch (e) {
      getBack();
      CustomDialog.showImageAlertDialog(
          title: Padding(padding: EdgeInsets.only(top: 10),
            child: MyText(txt: "تأكد من اتصال الانترنت", size: 15,),),
          img: "images/no-wifi.png", //successful dialog image
          buttonText: "حاول مجددا",
          onPressed: () {
            Get.back();
          }
      );
    }on TimeoutException catch (e) {

        getBack();
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            buttonText: "رجوع",
            onPressed: () {

              Get.back();
            }
        );
    }catch (e) {

        getBack();
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            buttonText: "رجوع",
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
}
