import 'package:get/get.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../app_routes.dart';
import '../login_screen/login_controller.dart';
import '../main.dart';
class StoreAuth extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (prefs!.getString('phone') != null &&prefs!.getString('password') != null) {
      // Static_Var.adminToken= prefs!.getString('Admintoken')!;
      return RouteSettings(name: AppRoutes.mainHome);
    }
  }
}
