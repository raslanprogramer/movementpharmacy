import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movementfarmacy/models/advertisement.dart';

import '../../../static/my_urls.dart';
class UserAdvertisementController extends GetxController
{
  List<Advertisement> adverts=[];
  bool hasFeched=false;
  Future fetch()async
  {
    if(hasFeched==false)
      {
        try {
          final response = await http.get(
            Uri.parse('${MyUrls.apiUrl}advs/get/${MyUrls.userCountry}'),
            headers: MyUrls.getHeadersList
          );
          print("i am in AdvertisementController in fetch function ,${response.statusCode.toString()}");
          if (response.statusCode == 200) {
            // final data = utf8.decode(response.bodyBytes);
            final element = jsonDecode(response.body);
            print(element);
            for(var adv in element['data'])
            {
              adverts.add(Advertisement.fromJson(adv));
            }
            hasFeched=true;
            update();
          }
          else {
            final element = jsonDecode(response.body);
            print("i am in Advertisement controller in catch function,response is ${element}");
          }
        } catch (e) {
          bool x=false;
        }
      }

  }
  @override
  void onInit() {
    fetch();
    super.onInit();
  }
}
