
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/admin/admin_login.dart';
import 'package:movementfarmacy/admin/admin_panel.dart';
import 'package:movementfarmacy/middleware/admin_auth.dart';
import 'package:movementfarmacy/middleware/store_auth.dart';
import 'package:movementfarmacy/static/my_urls.dart';
import 'package:movementfarmacy/views/bills/paymenents.dart';
import 'package:movementfarmacy/views/home/main_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'app_routes.dart';
import 'login_screen/screens/login_screen/login_screen.dart';
import 'static/notification_service.dart';
SharedPreferences? prefs;



///this function to receive notification in background mode
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if(message.notification!=null && message.data['img']!=null && message.data['img']!='')
    {
      NotificationService.showNotification(
          title: message.notification?.title ?? "",
          body: message.notification?.body ?? "",
          bigPicture:"${MyUrls.imgUrl}${message.data['img']}"
      );
    }
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  //initialize firebase messaging
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //initialize our awesome_notifications object
  await NotificationService.initializeNotification();


  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request permission for notifications
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );


if(settings.authorizationStatus==AuthorizationStatus.authorized)
  {
    FirebaseMessaging.onMessage.listen((RemoteMessage message)async {
      // Handle the notification here
      print("the data ruslan recieve is ${message.data}");
      NotificationService.showNotification(
          title: message.notification?.title ?? "",
          body: message.notification?.body ?? "",
          bigPicture:message.data['img']==null || message.data['img']==''?null:"${MyUrls.imgUrl}${message.data['img']}"
      );
    });


  }
  // FirebaseMessaging.instance.getInitialMessage().then(
  //       (value) => null
  // );

  prefs = await SharedPreferences.getInstance();

  MyUrls.userCountry=prefs!.getInt("country")??0;
  MyUrls.userPhone= prefs!.getString("phone")??"";
  MyUrls.userPassword=prefs!.getString("password")??"";

  MyUrls.adminPhone=prefs!.getString("adminPhone")??"713683090";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        textDirection: TextDirection.rtl,
        debugShowCheckedModeBanner: false,
        //  home: Login(),
        getPages: [
          GetPage(
            name: '/',
            middlewares: [StoreAuth()],
            page: () =>const LoginScreen(),
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: AppRoutes.adminLoging,
            middlewares: [AdminAuth()],
            page: () =>const AdminLogin(),
            transition: Transition.fadeIn,
          ),
          GetPage(
              name: AppRoutes.mainHome,
              page: () => MainHome()),
          GetPage(
              name: AppRoutes.payments,
              page: () => Payments()),
          GetPage(
              name: AppRoutes.adminPanel,
              page: () => AdminPanel())
        ]);
  }

}