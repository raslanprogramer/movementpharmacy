import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/models/admin_models/admin_bill.dart';
import 'package:movementfarmacy/static/fonts.dart';
import '../../admin/customers/customers_view.dart';
import '../widgets/MyText.dart';


class BillButton extends StatefulWidget {

  BillButton({required this.adminBill,required this.transferButton,required this.cancelButton,required this.userClickButton});

  final AdminBill adminBill;
  final void Function()? transferButton;
  final void Function()? cancelButton;
  final void Function()? userClickButton;


  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<BillButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:0.0,vertical: 6),

      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFF0BB000).withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide(color: Colors.black)),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))

              ),
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  SizedBox(

                    height: 40,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: (){
                        setState(() {
                          //this is to open and close the bill as need
                          widget.adminBill.isTapedOrNot = !widget.adminBill.isTapedOrNot;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: MyText(
                              txt: "التاريخ: ${DateTime.parse(widget.adminBill.createdAt.toString()).year}-${DateTime.parse(widget.adminBill.createdAt.toString()).month}-${DateTime.parse(widget.adminBill.createdAt.toString()).day} ${DateTime.parse(widget.adminBill.createdAt.toString()).hour}",
                              size: 14.0,
                            ),
                          ),
                          widget.adminBill.isTapedOrNot
                              ? const Icon(
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
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: MyText(
                            txt: "اسم العميل :",
                            size: 14.0,
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10,left: 10,top: 2),
                            child: MyText(
                              textDecoration: TextDecoration.underline,
                              txt: widget.adminBill.customer.name,
                              size: 14.0,
                            ),
                          ),
                          onTap: (){
                            widget.userClickButton;
                          },
                        ),
                        Expanded(
                          child: InkWell(
                            child:
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(right: 3.0,left: 10),
                              child: FittedBox(
                                child: MyText(
                                  txt: widget.adminBill.billNumber,
                                  size: 13.0,
                                ),
                              ),
                            ),
                            onTap: (){
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 200), // Animation duration
              curve: Curves.easeInOut, // Animation curve
              child: Visibility(
                visible: widget.adminBill.isTapedOrNot,
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
                                            flex:1,
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
                                  for(int i=0;i<widget.adminBill.orders.length;i++)
                                    Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(2)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex:3,
                                          child: Container(
                                            child: MyText(txt: "${widget.adminBill.orders[i]?.productName}", size: 16.0,family: Fonts.medium,),
                                          ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: MyText(txt: "${widget.adminBill.orders[i]?.productPrice}",size: 18.0,family: Fonts.medium,))
                                        ),
                                        Expanded(
                                            flex:1,
                                            child:Align(
                                                alignment: Alignment.center,
                                                child: MyText(txt: "${widget.adminBill.orders[i]?.quantity}",size: 18.0,family: Fonts.medium,))
                                        ),
                                        Expanded(
                                            flex:2,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: MyText(txt: (widget.adminBill.orders[i]!.productPrice!*widget.adminBill.orders[i]!.quantity!).toString(),size: 18.0,family: Fonts.medium,))
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: MyText(txt: "إجمالي الفاتورة",size: 17,))),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: MyText(txt: "${widget.adminBill.totalPrice}",size: 17,)),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            onTap: widget.transferButton,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))
                              ),
                              height: 40,
                              alignment: Alignment.center,
                                padding: EdgeInsets.only(right: 10),
                                child: MyText(txt:"ترحيل",size: 17,)),
                          )),
                      InkWell(
                        child: Container(
                          height: 40,
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 10),
                            child: MyText(txt:"إلغاء",size: 17,)),
                        onTap:widget.cancelButton,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
