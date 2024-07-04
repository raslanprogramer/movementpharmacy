import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movementfarmacy/theme/AppColor.dart';

import '../../static/my_urls.dart';
import '../../views/widgets/MyText.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../views/widgets/custom_dialog.dart';

class AddEmploy extends StatefulWidget {
  const AddEmploy({Key? key}) : super(key: key);

  @override
  State<AddEmploy> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AddEmploy> {

  var items = [
    'اليمن',
    'السعودية'
  ];
  late String dropdownvalue ;
  late String dropdownvalue2;

  var items2 = [
    'مشرف بالدولة',
    'موصل طلبات'
  ];
  GlobalKey<FormState> formKey=GlobalKey<FormState>();
  TextEditingController name=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController password=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    dropdownvalue=items[0];
    dropdownvalue2=items2[0];
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
                  controller: name,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "اسم الموظف",

                    prefixIcon: Icon(Icons.person,color: Colors.green.shade700,),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(txt: "الوظيفة: ",size: 15,),
                    SizedBox(width: 10,),
                    DropdownButton(
                      // dropdownColor:AppColors.primaryMainGreen,
                      // underline: Divider(color: Colors.white,),
                      value: dropdownvalue2,
                      alignment: Alignment.bottomRight,
                      icon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                      items: items2.map((String items) {
                        return DropdownMenuItem(
                          alignment: Alignment.centerRight,
                          value: items,
                          child: MyText(txt:items,size: 15,color:Colors.black,),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if(newValue!=dropdownvalue2)
                        {
                          if(newValue=='موصل طلبات')
                          {
                          }
                          else
                          {
                          }
                          setState(() {
                            dropdownvalue2 = newValue!;
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
                    addEmploy();
                  }, child: MyText(txt: "انطلاق",)))
            ],
          ),
        ),
      ),
    );
  }
  addEmploy()async
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
        Uri.parse('${MyUrls.apiUrl}adminpanel/addempoly'),
        headers: MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": MyUrls.adminControllerPhone,
              "password": MyUrls.adminPassword,
              "country":MyUrls.adminCountry,
              "userphone":phone.text,
              "userpassword":password.text,
              "usercountry":dropdownvalue==items[0]?0:1,
              "userroll":dropdownvalue2==items2[0]?2:3,
              "username":name.text}),
      ).timeout(MyUrls.timesOutInSeconds);
      print("i am in BillController in fetch function ,${response.statusCode.toString()}");
      if (response.statusCode == 201) {
        getBack();
        // final data = utf8.decode(response.bodyBytes);
        final element = jsonDecode(response.body);
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تم اضافة موظف بنجاح",size: 15,),),
            img: "images/tick.png", //successful dialog image
            buttonText: 'رجوع',
            onPressed: () {
              Get.back();
            }
        );

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
