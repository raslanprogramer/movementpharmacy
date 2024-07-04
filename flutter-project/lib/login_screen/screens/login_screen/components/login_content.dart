import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movementfarmacy/app_routes.dart';
import 'package:movementfarmacy/login_screen/login_controller.dart';

import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';
import 'package:get/get.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  final TextEditingController name=TextEditingController();
  final TextEditingController phone=TextEditingController();
  final TextEditingController password=TextEditingController();
  final TextEditingController hasPhone=TextEditingController();
  final TextEditingController hasPassword=TextEditingController();


  LoginController loginController=Get.find();
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;

  Widget inputField(String hint, IconData iconData,{required TextEditingController? txtController}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
        child: SizedBox(
          height: 50,
          child: Material(
            elevation: 8,
            shadowColor: Colors.black87,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            child: TextField(
              controller:txtController,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: hint,
                prefixIcon: Icon(iconData),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(String title,{required void Function() pressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () {pressed();},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          backgroundColor: kSecondaryColor,
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'أو',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Widget logos() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Image.asset('assets/images/facebook.png'),
  //         const SizedBox(width: 24),
  //         Image.asset('assets/images/google.png'),
  //       ],
  //     ),
  //   );
  // }

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'نسيت كلمة السر',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            // color: kSecondaryColor,
            color: Color(0xFFC9FADF)
          ),
        ),
      ),
    );
  }

  void  login()async
  {
    print(name.text);
    print(phone.text);
    print(password.text.toString());
    loginController.name=name.text.toString();
    loginController.phone=phone.text.toString();
    loginController.password=password.text.toString();
    bool result=await loginController.login();
    if(result==true)
      {
        Get.offNamed(AppRoutes.mainHome);
      }
    else
      {

      }
  }
  void hasAcount()async
  {
    print(hasPhone.text);
    print(hasPassword.text);
    loginController.phone=hasPhone.text.toString();
    loginController.password=hasPassword.text.toString();
    bool result=await loginController.hasAcount();
    if(result==true)
    {
      Get.offNamed(AppRoutes.mainHome);
    }
    else
    {

    }
  }
  @override
  void initState() {
    createAccountContent = [
      inputField('اسم البقالة', Icons.person,txtController: name),
      inputField('رقم الهاتف', Icons.phone_android_sharp,txtController: phone),
      inputField('كلمة السر', Icons.lock_clock_sharp,txtController: password),
      loginButton('تسجيل',pressed: login),
      orDivider(),
      //اذا كنا نود أن نسجل تسجيل خول باستخدام فيسبوك و جوجل
      // logos(),
    ];

    loginContent = [
      inputField('رقم الهاتف', Icons.mail_lock_outlined,txtController: hasPhone),
      inputField('كلمة السر', Icons.lock_clock_outlined,txtController: hasPassword),
      loginButton('تسجيل',pressed: hasAcount),
      forgotPassword(),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    try{
      // ChangeScreenAnimation.dispose();
    }catch(e)
    {
      //po
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 110,
          right: MediaQuery.of(context).size.width/2-150,
          child: const TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              ),
            ],
          ),
        ),
         Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: BottomText(),
          ),
                 ),

      ],
    );
  }
}
