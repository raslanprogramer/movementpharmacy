import 'package:flutter/material.dart';
import 'package:movementfarmacy/static/fonts.dart';
import '../../models/bill.dart';
import '../widgets/MyText.dart';


class Properties_Button extends StatefulWidget {

   Properties_Button({super.key, required this.bill});
  final Bill bill;
// var Title;
  //
  // var description;

  // final List<int> list_property; //as List

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<Properties_Button> {
  // bool _expanded = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.0,right: 8.0,bottom: 10),

      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0BB000).withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: (){
                setState(() {
                  widget.bill.isTapedOrNot=!widget.bill.isTapedOrNot;
                  // _expanded = !_expanded;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(color: Colors.black)),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))

                ),
                // decoration: BoxDecoration(
                //   color: Color(0xFF0BB000).withOpacity(0.2),
                //   borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                // ),
                padding: EdgeInsets.only(left: 20),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                 Padding(
                   padding: EdgeInsets.only(right: 10),
                    child: MyText(
                      txt: "التاريخ: ${DateTime.parse(widget.bill.createdAt.toString()).year}-${DateTime.parse(widget.bill.createdAt.toString()).month}-${DateTime.parse(widget.bill.createdAt.toString()).day}",
                      size: 16.0,
                    ),
                  ),
                    widget.bill.isTapedOrNot
                        ? Icon(
                      Icons.keyboard_arrow_up_outlined,
                      color: Colors.green,
                      size: 30,
                    )
                        : Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 200), // Animation duration
              curve: Curves.easeInOut, // Animation curve
              child: Visibility(
                visible: widget.bill.isTapedOrNot,
                child: Container(
                  // color: Colors.white,
        
                  child: Transform.translate(
                    offset: Offset(0.0, 0),
                    child: Container(
                      child: LayoutBuilder(
                        builder: (BuildContext context,
                            BoxConstraints constraints) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              // padding:
                              //     EdgeInsets.only(left: 20, right: 20),
                              // Adjust the width as needed
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 3,top: 1),
                                    height: 30,
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(2)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.withOpacity(.5),
                                              // blurRadius: 1.0,
                                            offset: Offset(1, 2)
                                          )
                                        ]
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex:3,
                                          child: Container(
                                            child: MyText(txt: "المنتج", size: 12.0,fontweight: FontWeight.bold,),
                                          ),
                                        ),
                                        Expanded(
                                            flex:2,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: MyText(txt: "السعر",size: 12.0,))
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: MyText(txt: "الكمية",size: 12.0,))
                                        ),
                                        Expanded(
                                            flex:2,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: MyText(txt: "الإجمالي",size: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Divider(),
                                  // if(widget.description!=null)
                                  // for (int i = 0;
                                  // i < widget.description!.length;
                                  // i++)
                                  for(int i=0;i<widget.bill.orders.length;i++)
                                    Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(2)),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //       color: Colors.grey.withOpacity(.5),
                                        //       // blurRadius: 1.0,
                                        //     offset: Offset(0.5, 0.5)
                                        //   )
                                        // ]
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex:3,
                                          child: Container(
                                            child: MyText(txt: widget.bill.orders[i]?.productName, size: 15.0,family: Fonts.medium,),
                                          ),
                                        ),
                                        Expanded(
                                            flex:2,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: MyText(txt: widget.bill.orders[i]?.productPrice.toString(),size: 17.0,family: Fonts.medium,))
                                        ),
                                        Expanded(
                                            flex:1,
                                            child:Align(
                                                alignment: Alignment.center,
                                                child: MyText(txt: widget.bill.orders[i]?.quantity.toString(),size: 17.0,family: Fonts.medium,))
                                        ),
                                        Expanded(
                                            flex:2,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: MyText(txt: (widget.bill.orders[i]!.productPrice!*widget.bill.orders[i]!.quantity!).toString(),size: 17.0,family: Fonts.medium,))
                                        ),
                                      ],
                                    ),
                                  ),

        

        
                                ],
                              ));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.symmetric(horizontal: BorderSide(color: Colors.black)),
                  color: Color(0xFF0BB000).withOpacity(0.2),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))

              ),
              padding: EdgeInsets.only(left: 20),
              height: 40,
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: MyText(txt: "إجمالي الفاتورة",size: 17,))),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: MyText(txt: widget.bill.totalPrice.toString(),size: 17,)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
