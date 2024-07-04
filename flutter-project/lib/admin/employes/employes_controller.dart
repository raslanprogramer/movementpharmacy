import 'dart:async';

import 'package:get/get.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../models/admin_models/employ.dart';
import '../../static/my_urls.dart';
import '../../views/widgets/MyText.dart';
import '../../views/widgets/custom_dialog.dart';
class EmploysController extends GetxController
{
  List<Employ> employs=[];
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
          Uri.parse('${MyUrls.apiUrl}admin/readuser'),
          headers:MyUrls.postHeadersList,
          body: jsonEncode(
              {"phone": MyUrls.adminControllerPhone,"password": MyUrls.adminPassword,"country":MyUrls.adminCountry}),
        ).timeout(MyUrls.timesOutInSeconds);
        print(response.statusCode.toString());
        if (response.statusCode == 200) {
          // final data = utf8.decode(response.bodyBytes);
          final element =jsonDecode(response.body);
          print("i am in EmployController in fetch function ,response body is${element}");
          for(var elem in element['data'])
          {
            employs.add(Employ.fromJson(elem));
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
              img: "images/error_message.jpg", //successful dialog image
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
   deleteEmploy(String employId)
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

      final response = await http.post(
        Uri.parse('${MyUrls.apiUrl}adminpanel/deleteadmin'),
        headers:MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": MyUrls.adminControllerPhone,"password": MyUrls.adminPassword,"country":MyUrls.adminCountry,
            "userid":employId}),
      ).timeout(MyUrls.timesOutInSeconds);
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
       employs.clear();
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
  updateEmploy(Employ employId) async{
    try {
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

      final response = await http.post(
        Uri.parse('${MyUrls.apiUrl}admin/updateuser'),
        headers: MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": MyUrls.adminControllerPhone,"password": MyUrls.adminPassword,"country":MyUrls.adminCountry,
              "userid":employId.id,
            "userphone":employId.phone,
            "userpassword":employId.password,
            "username":employId.name,
            "userroll":employId.position=="موصل طلبات"?'3':'2',
            "usercountry":employId.country=="اليمن"?0:1}),
      ).timeout(MyUrls.timesOutInSeconds);
      print("متى كانت حرب غزة");
      print(response.statusCode);
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
        employs.clear();
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



  dialogToUpdateStoreData(Employ employ)
  {
    TextEditingController name=TextEditingController();
    TextEditingController phone=TextEditingController();
    TextEditingController password=TextEditingController();
    final GlobalKey<FormState> formKey=GlobalKey<FormState>();
    String country=employ.country.toString();

    name.text=employ.name??'';
    phone.text=employ.phone??'';
    password.text=employ.password??'';

    Employ updatableEmploy=Employ(
      id: employ.id,
    );
    var items2 = [
      'مشرف بالدولة',
      'موصل طلبات'
    ];
    var items = [
      'اليمن',
      'السعودية'
    ];
     String dropdownvalue2=employ.position??items2[0];

     String dropdownvalue= employ.country??items[1];
    dropdownvalue=items[0];
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
          child: Form(
            key:formKey,
            child: SingleChildScrollView(
              child: GetBuilder<EmploysController>(
                builder: (employCtrl) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                        ),
                        child:  const MyText(
                          color: Colors.white,
                          size: 16,
                          txt: "تعديل بيانات الموظف",
                        ),
                      ),

                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: MyText(
                              size: 15,
                              txt: "الاسم: ",
                            ),
                          ),
                          SizedBox(
                              width: 150,
                              child: TextFormField(
                                controller: name,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: MyText(
                              size: 15,
                              txt: "الهاتف: ",
                            ),
                          ),
                          SizedBox(
                              width: 150,
                              child: TextFormField(
                                controller: phone,
                                validator: (value)
                                {
                                  if(value==null || value.isEmpty)
                                  {
                                    return 'رقم هاتف خاظئ';
                                  }
                                  return null;
                                },
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: MyText(
                              size: 15,
                              txt: "كلمة السر: ",
                            ),
                          ),
                          SizedBox(
                              width: 100,
                              child: TextFormField(
                                minLines: 2,
                                maxLines: 3,
                                controller: password,
                                validator: (value)
                                {
                                  if(value==null || value.isEmpty||value.length<10)
                                  {
                                    return 'ادخل 10 على الأقل';
                                  }
                                  return null;
                                },
                              )),
                        ],
                      ),
                      const SizedBox(height: 3,),

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
                                  dropdownvalue = newValue!;
                                  update();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4,),
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
                                  dropdownvalue2 = newValue!;
                                  update();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      // Image.asset(img,height: iconHeight),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap:(){
                                  if(formKey.currentState!.validate())
                                  {
                                    updatableEmploy.name=name.text;
                                    updatableEmploy.phone=phone.text;
                                    updatableEmploy.password=password.text;
                                    updatableEmploy.country=dropdownvalue;
                                    updatableEmploy.position=dropdownvalue2;
                                    updateEmploy(updatableEmploy);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10,top: 5),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color:   const Color(0xFF0BB000),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: const Center(
                                    child: FittedBox(
                                      child: MyText(
                                        txt: "حفظ",
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
                  );
                }
              ),
            ),
          ),
        ),
      ),

    );

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