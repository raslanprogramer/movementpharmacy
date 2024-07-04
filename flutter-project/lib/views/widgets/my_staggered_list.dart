import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
class MyStaggeredList extends StatelessWidget {
  const MyStaggeredList({Key? key, required this.widgets, this.listController=null}) : super(key: key);
  final List<Widget> widgets;
  final ScrollController? listController;
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
    controller:listController ,
        padding: EdgeInsets.all(10),
        physics:
        BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: Duration(milliseconds: 300),
            child: SlideAnimation(
              duration: Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(milliseconds: 2500),
                  child: widgets[index]),
            ),
          );
        },
      ),
    );
  }
}
