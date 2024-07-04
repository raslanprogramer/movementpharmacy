import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movementfarmacy/views/home/controllers/user_advertisment_controller.dart';
import '../../../main.dart';
import '../../../models/category.dart';
import '../../../static/helper_fuctions.dart';
import '../../../static/my_urls.dart';
import '../../widgets/MyText.dart';
import '../../widgets/custom_dialog.dart';
class CategoryController extends GetxController
{
  List<Category> categories=[];
  // bool isReady=false;
  bool isLocationUpload=false;//to detected if the location of user is null in the server
  bool isLoad=false;
  bool connectionError=false;
  late UserAdvertisementController advertisementController;
  Future fetch()async
  {
    if(isLoad!=true)
      {


        checkAppVersion();//تحقق من نسخة التطبيق
        isLoad=true;
        try {

          ///
          advertisementController=Get.find();//من أجل ان نقوم بعملية جلب الاعلانات في كل مرة يفشل فيها بسبب الانترنت
          advertisementController.fetch();
          ////


          final response = await http.get(
            Uri.parse('${MyUrls.apiUrl}category/${MyUrls.userCountry}'),
            headers:MyUrls.getHeadersList,
          ).timeout(MyUrls.timesOutInSeconds);
          print("i am in CategoryController in fetch function ,${response.statusCode.toString()}");
          if (response.statusCode == 200) {
            // final data = utf8.decode(response.bodyBytes);
            final element = jsonDecode(response.body);
            print(element);
            for(var cat in element['data'])
            {
              categories.add(Category.fromJson(cat));
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
  
  uplaodLocation()async
  {
    if(!isLocationUpload)
      {
        try {
          final response = await http.get(
            Uri.parse('${MyUrls.apiUrl}store_select?phone=${MyUrls.userPhone}&password=${MyUrls.userPassword}'),
            headers: MyUrls.getHeadersList,
            // headers: Static_Var.headers
          );
          print("i am in CategoryController in fetch function ,${response.statusCode.toString()}");
          if (response.statusCode == 200 ) {
            // final data = utf8.decode(response.bodyBytes);
            final element = jsonDecode(response.body);
            if(element['location']=='null' || element['location']==null)
            {
              bool locResult=await getUserLocation();
              if(locResult==true)
                {
                  final response = await http.post(
                    Uri.parse('${MyUrls.apiUrl}store_update'),
                    headers:MyUrls.postHeadersList,
                    body: jsonEncode(
                        {"phone": MyUrls.userPhone, "password": MyUrls.userPassword, "country":MyUrls.userCountry,"location":MyUrls.userLocation}),
                  );
                }
              else
                {
                 await Future.delayed(Duration(seconds: 20)).then((value){
                    uplaodLocation();
                  });
                }
            }
            else
              {
                isLocationUpload=true;
              }
          }
          else
            {
              Future.delayed(Duration(seconds: 20)).then((value){
                uplaodLocation();
              });
            }
        } catch (e) {
          Future.delayed(Duration(seconds: 20)).then((value){
            uplaodLocation();
          });
        }
      }
  }
  bool hasCheckVersion=false;
  Future checkAppVersion()async
  {
    if(!hasCheckVersion)
      {
       try
           {
             final response = await http.post(
               Uri.parse('${MyUrls.apiUrl}app_version'),
               headers:MyUrls.postHeadersList,
               body: jsonEncode(
                   {"phone": MyUrls.userPhone, "password": MyUrls.userPassword, "version":MyUrls.appVersion}),
             ).timeout(Duration(seconds: 5));
             if(response.statusCode==200)
             {
               final element = jsonDecode(response.body);
               if(element['message']=="no")
               {
                 String? url=element['url'];
                 if(element['required']=="yes")
                 {
                   Get.dialog(
                     PopScope(
                       canPop: false,
                       child: Dialog(
                         shape: const RoundedRectangleBorder(
                             borderRadius:
                             BorderRadius.all(
                                 Radius.circular(10.0))),
                         insetPadding: EdgeInsets.symmetric(horizontal: Get.width/6),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Image.asset("images/error_message.jpg",height: 120),
                             FittedBox(
                               child: Container(
                                   alignment: Alignment.center,
                                   width: 180,
                                   child: MyText(txt: "عزيزنا العميل عليك تحديث التطبيق لتتمكن من الاستخدام",size: 16,)),
                             ),
                             InkWell(
                               splashColor: Colors.transparent,
                               highlightColor: Colors.transparent,
                               onTap:(){
                                 HelperFunctions.openWebSite(url??'');
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
                                       txt: "تحديث",
                                       color: Colors.white,
                                       size: 18,
                                     ),
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                     ),
                   );
                 }
                 else
                 {
                   Get.dialog(
                     PopScope(
                       canPop: true,
                       child: Dialog(
                         shape: const RoundedRectangleBorder(
                             borderRadius:
                             BorderRadius.all(
                                 Radius.circular(10.0))),
                         insetPadding: EdgeInsets.symmetric(horizontal: Get.width/6),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Image.asset("images/error_message.jpg",height: 120),
                             FittedBox(
                               child: Container(
                                   alignment: Alignment.center,
                                   width: 180,
                                   child: MyText(txt: "تتوفر نسخة حديثة للتطبيق لكي تستفيد من جميع الميزات",size: 16,)),
                             ),
                             InkWell(
                               splashColor: Colors.transparent,
                               highlightColor: Colors.transparent,
                               onTap:(){
                                 HelperFunctions.openWebSite(url??'');
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
                                       txt: "تحديث",
                                       color: Colors.white,
                                       size: 18,
                                     ),
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                     ),
                   );
                 }
                 hasCheckVersion=true;
               }
             }
           }catch(e)
    {
      bool? mmmm;
    }
      }

  }
  @override
  void onInit() {
    fetch();
    uplaodLocation();
    super.onInit();
  }

}
Future<bool> getUserLocation() async {
  //this command is to show user alert to give it that we need permission or goes off from application
  // await showLocationPermissionDialog();



  Location location = Location();


  //اولا نتفحص اذا كان المستخدم مفعل خدمة ال GPS واذا كان غير مفعلها نطالبه بتشغيلها
  // Check if location services are enabled
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (serviceEnabled) {
        print("the service is enabled:$serviceEnabled");

        PermissionStatus permissionGranted= await location.hasPermission();
        if (permissionGranted == PermissionStatus.denied) {
          //هنا طلبنا الاذن
          permissionGranted = await location.requestPermission();
          if (permissionGranted == PermissionStatus.granted) {
            try {
              LocationData position = await location.getLocation();
              double? latitude = position.latitude;
              double? longitude = position.longitude;
              if(latitude!=null && longitude!=null)
              {
                prefs?.setString("location", "$latitude,$longitude");
                print('Latitude: $latitude, Longitude: $longitude');
              }
              else
              {
                prefs?.setString("location", "null");
              }
              //this urls ius static ,i have use it in more places
              MyUrls.userLocation=prefs?.getString("location")??'null';

              String countryCode = await getCountryFromCoordinates(latitude!, longitude!);
              print(countryCode);
              if(countryCode=="YE" ||countryCode=="SA")
              {
                if(countryCode=="YE")
                {
                  prefs?.setInt("country", 0);
                }
                else
                {
                  prefs?.setInt("country", 1);
                }
                //this urls ius static ,i have use it in more places
                MyUrls.userCountry=prefs?.getInt("country")??0;
              }
              return true;

            } catch (error) {
              // Error occurred while retrieving the location
              prefs!.setInt('country',0);//default value is yemen
              print('Error: $error');
            }
          }
          else
            {
              return false;
            }
        }
        // Location permission granted, you can proceed with accessing the location
      }
      else
        {
          return false;
        }
      return false;
  }
  else
    {
      PermissionStatus permissionGranted= await location.hasPermission();
      if (permissionGranted == PermissionStatus.granted) {
        try {
          LocationData position = await location.getLocation();
          double? latitude = position.latitude;
          double? longitude = position.longitude;
          if(latitude!=null && longitude!=null)
          {
            prefs?.setString("location", "$latitude,$longitude");
            print('Latitude: $latitude, Longitude: $longitude');
          }
          else
          {
            prefs?.setString("location", "null");
          }
          //this urls ius static ,i have use it in more places
          MyUrls.userLocation=prefs?.getString("location")??'null';

          String countryCode = await getCountryFromCoordinates(latitude!, longitude!);
          print(countryCode);
          if(countryCode=="YE" ||countryCode=="SA")
          {
            if(countryCode=="YE")
            {
              prefs?.setInt("country", 0);
            }
            else
            {
              prefs?.setInt("country", 1);
            }
            //this urls ius static ,i have use it in more places
            MyUrls.userCountry=prefs?.getInt("country")??0;
          }
          return true;

        } catch (error) {
          // Error occurred while retrieving the location
          prefs!.setInt('country',0);//default value is yemen
          print('Error: $error');
        }
        return false;
      }
      return false;
    }
  // Check if location permission is granted
}
// Function to extract the country from latitude and longitude
Future<String> getCountryFromCoordinates(
    double latitude, double longitude) async {
  try {
    List<geo.Placemark> placeMark =
    await geo.placemarkFromCoordinates(latitude, longitude);
    if (placeMark.isNotEmpty) {
      geo.Placemark placeMarkResult = placeMark.first;
      return placeMarkResult.isoCountryCode  ?? '';//رمز الدولة وليس اسم الدزلة
      //if we want city
      // return placeMarkResult.locality ?? '';
    }
  } catch (e) {
    print('Error: $e');
  }
  return '';
}

