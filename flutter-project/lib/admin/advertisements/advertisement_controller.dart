import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movementfarmacy/models/advertisement.dart';

import '../../static/my_urls.dart';
import '../../views/widgets/MyText.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../views/widgets/custom_dialog.dart';

class AdvertisementController extends GetxController
{

  List<Advertisement> advertisements=[];
  bool connectionError=false;
  bool isLoad=false;
  fetch()async{
    if(isLoad==false)
      {
        isLoad=true;
        update();
        try {
          final response = await http.get(
            Uri.parse('${MyUrls.apiUrl}advs/get/${MyUrls.adminCountry}'),
            headers: MyUrls.getHeadersList
          ).timeout(Duration(seconds: 6));
          print("i am in CategoryController in fetch function ,${response.statusCode.toString()}");
          if (response.statusCode == 200) {
            // final data = utf8.decode(response.bodyBytes);
            final element = jsonDecode(response.body);
            print(element);
            int countr=0;
            for(var adv in element['data'])
            {
              print("${countr++}");
              advertisements.add(Advertisement.fromJson(adv));
            }
            connectionError=false;
            update();
          }
          else {
            final element = jsonDecode(response.body);
            print(response.body.toString());
            CustomDialog.showImageAlertDialog(
                title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
                img: "images/no-wifi.png", //successful dialog image
                buttonText: "حاول مجددا",
                onPressed: () {
                  fetch();
                  Get.back();
                }
            );
            connectionError=true;
            isLoad=false;
            update();////////
          }
        } on SocketException catch (e) {
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
          update();///////////
        } catch (e) {
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
          update();/////////
        }
      }

  }



  sendRequest()async
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

    try{
      var request = http.MultipartRequest('POST', Uri.parse('${MyUrls.apiUrl}advs/insert'));
      // Create a multipart file from the image file
      var image = await http.MultipartFile.fromPath("img", selectedImage!.path);
      request.files.add(image);
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers.addAll(MyUrls.postHeadersList);//this will remove after we get respect host server

      // Set the body
      request.fields['phone'] =MyUrls.adminControllerPhone;
      request.fields['password'] = MyUrls.adminPassword;
      request.fields['country'] = MyUrls.adminCountry.toString();


      final response=await request.send();
      if(response.statusCode==201)
      {
        getBack();
        getBack();
        selectedImage=null;
        CustomDialog.showImageAlertDialog(
            title:const MyText(txt: "تمت العملية بنجاح",),
            img: "images/tick.png", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        advertisements.add(Advertisement.fromJson(jsonResponse['data']));
        update();
      }
      else
      {
        getBack();
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        CustomDialog.showImageAlertDialog(
            title: MyText(txt: "${jsonResponse['message']}",),
            img: "images/error_message.png", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );
        // var jsonResponse = jsonDecode(responseBody);
        // print(jsonResponse.toString());
      }
    }catch(e)
    {
      getBack();
      CustomDialog.showImageAlertDialog(
          title: MyText(txt: "تحقق من اتصال الانترنت",),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
    }


  }
  addAdvertisement()
  {
    Get.dialog(
        Directionality(
            textDirection: TextDirection.rtl,
            child: Dialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(
                      Radius.circular(20.0))),
              child: GetBuilder<AdvertisementController>(
                  builder: (_) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [

                          selectedImage != null
                              ? Center(child: Image.file(selectedImage!,height: 100,width: 100,))
                              : Container(width: 100,height: 100,color: Colors.grey.shade400,alignment: Alignment.center,child: FittedBox(child: MyText(txt: "عليك اختيار صورة",textAlign: TextAlign.center,color: Colors.red,),)),
                          InkWell(
                            highlightColor: Colors.transparent,
                            onTap:(){
                              pickImage();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              height: 40,
                              width: 180,
                              decoration: BoxDecoration(
                                color:   const Color(0xFF0BB000),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Center(
                                child: FittedBox(
                                  child: MyText(
                                    txt: "اختر صورة",
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap:(){
                              if(selectedImage!=null)
                                {
                                  sendRequest();
                                }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              height: 40,
                              decoration: BoxDecoration(
                                color:   const Color(0xFF0BB000),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Center(
                                child: FittedBox(
                                  child: MyText(
                                    txt: "حفظ",
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    );
                  }
              ),
            )
        ));

  }
  File? selectedImage;


  Future deleteAdv(int index)async
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
        Uri.parse('${MyUrls.apiUrl}advs/delete'),
        headers: MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": MyUrls.adminControllerPhone, "password": MyUrls.adminPassword,"country":MyUrls.adminCountry,"advs_id":advertisements[index].id}),
      ).timeout(Duration(seconds: 5));
      print(response.statusCode.toString());
      if (response.statusCode == 201) {
        // final data = utf8.decode(response.bodyBytes);
        final element = jsonDecode(response.body);

        advertisements.removeAt(index);
        getBack();
        // waitDelete=false;
        update();
        return true;
      }
      else {
        getBack();
        final element = jsonDecode(response.body);
        print(response.body.toString());
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}",size: 15,),),
            img: "images/error_message.png", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );
        // waitDelete=false;
        return false;
      }
    }catch (e) {

      // waitDelete=false;
      getBack();
      print("Error:$e");
      CustomDialog.showImageAlertDialog(
          title: Text( "ليس هناك اتصال بالانترنت",),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
      return false;
    }
  }
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      selectedImage = File(pickedImage.path);
      print(selectedImage?.path.toString());
      update();
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