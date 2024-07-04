import 'package:get/get.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../app_routes.dart';
import '../main.dart';
class AdminAuth extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (prefs!.getString('adminpassword') != null && prefs!.getString('adminpassword') !="" && prefs?.getString("admin_position")!=null && prefs?.getString("admin_position")!="") {
      return RouteSettings(name: AppRoutes.adminPanel);
    }
  }
}
