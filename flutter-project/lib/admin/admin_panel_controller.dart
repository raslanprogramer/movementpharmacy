import 'package:get/get.dart';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

import '../static/my_urls.dart';
class AdminPanelController extends GetxController {
  bool isFetched = false;
  int? counter0;
  int? counter1;

  fetch() async
  {
    if(isFetched==false)
      {
        try {
          final response = await http.post(
            Uri.parse('${MyUrls.apiUrl}adminpanel/maininfromation'),
            headers: MyUrls.postHeadersList,
            body: jsonEncode(
                {"phone": MyUrls.adminControllerPhone,
                  "password": MyUrls.adminPassword,
                  "country": MyUrls.adminCountry}),
          ).timeout(MyUrls.timesOutInSeconds);
          print(response.statusCode.toString());
          if (response.statusCode == 200) {
            // final data = utf8.decode(response.bodyBytes);
            final element = jsonDecode(response.body);
            counter0 = element['counter0']; //الطلبات الجديدة
            counter1 = element['counter1']; //طلبات قيد التوصيل
            isFetched = true;
            update();
          }
          else {
            if(isFetched==false) {
              Future.delayed(Duration(seconds: 10)).then((value) => fetch());
            }
          }
        } catch (e) {
          if(isFetched==false) {
            Future.delayed(Duration(seconds: 10)).then((value) => fetch());
          }
        }
      }
      }
      @override
  void onInit() {
    fetch();
    // TODO: implement onInit
    super.onInit();
  }

}