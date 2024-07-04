import 'package:flutter/material.dart';


import '../../../utils/helper_functions.dart';
import '../animations/change_screen_animation.dart';
import 'login_content.dart';

class TopText extends StatefulWidget {
  const TopText({Key? key}) : super(key: key);

  @override
  State<TopText> createState() => _TopTextState();
}

class _TopTextState extends State<TopText> {
  @override
  void initState() {
    ChangeScreenAnimation.topTextAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.wrapWithAnimatedBuilder(
      animation: ChangeScreenAnimation.topTextAnimation,
      child:ChangeScreenAnimation.currentScreen == Screens.createAccount?
      const SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("تسجيل",style:  TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),),
            Text("الدخول",style:  TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),)
          ],
        ),
      ):const SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("مرحباً",style:  TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),),
            Text("بعودتك",style:  TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),)
          ],
        ),
      )
    );
  }
}
