import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/static/my_urls.dart';
import '../main.dart';
import '../views/widgets/MyText.dart';




  Future getUserLocation() async {
    //this command is to show user alert to give it that we need permission or goes off from application
   // await showLocationPermissionDialog();



    Location location = Location();


    //اولا نتفحص اذا كان المستخدم مفعل خدمة ال GPS واذا كان غير مفعلها نطالبه بتشغيلها
    // Check if location services are enabled
   bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      //هنا جعلنا الموقع الجغرافي للمستخدم الزامي لستخدام التطبيق
      for(;;)
        {
          serviceEnabled = await location.requestService();
          if (serviceEnabled) {
            print("the service is enabled:$serviceEnabled");
            break;
            // Location services are disabled, handle accordingly
          }
        }
    }

    //هنا طالبنا المستخدم بالاذن بالوصول الى موقعه الجغرافي
    // Check if location permission is granted
    PermissionStatus permissionGranted= await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      //هنا طلبنا الاذن بشكل الزامي
      for(;;)
        {
          permissionGranted = await location.requestPermission();
          if (permissionGranted == PermissionStatus.granted) {
            // Location permission denied, handle accordingly
            break;
          }
        }

    }


    // Location permission granted, you can proceed with accessing the location
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

    } catch (error) {
      // Error occurred while retrieving the location
      prefs!.setInt('country',0);//default value is yemen
      print('Error: $error');
    }
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

Future<bool> showLocationPermissionDialog()async {
    bool accept=false;
 await Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        child: AlertDialog(
          contentPadding: const EdgeInsets.only(top: 8.0,left: 15.0,right: 15.0,bottom: 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
          title: const MyText(
            txt: 'تصريح الموقع',
          ),
          content: const Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: MyText(
                    txt: "قم بالسماح للتطبيق الوصول الى الموقع لتحسين تجربتك",
                    size: 14,
                  ),
                ),
              ),
              Icon(
                Icons.location_on,
                size: 35,
                color: Colors.red,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.start,
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextButton(
                style: ButtonStyle(overlayColor:MaterialStateProperty.all(Colors.grey.shade400) ),
                child: const MyText(
                  txt: 'موافق',
                  family: 'Bold',
                ),
                onPressed: () {
                  accept=true;
                  Get.back();
                  // Perform necessary actions when the user allows location access
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextButton(
                style: ButtonStyle(overlayColor:MaterialStateProperty.all(Colors.red.shade200) ),
                child: const FittedBox(
                  child: MyText(
                    txt: 'خروج من التطبيق',
                    family: 'Bold',
                  ),
                ),
                onPressed: () {
                  if(Platform.isAndroid)
                  {
                    exit(0);
                  }
                  Get.back();
                },
              ),
            ),
          ],
        ),
      )
  );
 return accept;

}