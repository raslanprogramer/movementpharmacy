import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:movementfarmacy/theme/AppColor.dart';
import 'package:movementfarmacy/views/bills/payment_controller.dart';
import 'package:movementfarmacy/views/widgets/MyText.dart';
import 'package:movementfarmacy/views/widgets/Properties_Button.dart';
import 'package:movementfarmacy/views/widgets/my_staggered_list.dart';

class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  ScrollController listController=ScrollController();
  PaymentController _paymentController=Get.find();
  String dropdownvalue = 'تحت الطلب';

  var items = [
    'تحت الطلب',
    'تم الطلب',
  ];
  @override
  void dispose() {
    listController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    listController.addListener(() {
      if (listController.position.pixels >= listController.position.maxScrollExtent-30) {
        if(_paymentController.isLoad==false) {
          _paymentController.fetch();
          if(_paymentController.startPagnition==true)
            {
              setState(() {
              });
            }
          print("i am in Paymenents statefulWidget in listController condition to fetch more data");
        }
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<PaymentController>(
        builder: (paymentController) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar:AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor:AppColors.primaryMainGreen,
              shadowColor: null,
              title: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
                  ),
                  Expanded(child:
                  Center(
                    child: MyText(
                      txt: "المشتريات",
                      color:Colors.white,
                    ),
                    // child: Text("الأدوية",
                    //   style: TextStyle(color:
                    //   Colors.white.withOpacity(.7),
                    //   fontFamily:'Black.otf' ),)

                  )),

                  DropdownButton(
                    dropdownColor:AppColors.primaryMainGreen,
                    // underline: Divider(color: Colors.white,),
                    value: dropdownvalue,
                    alignment: Alignment.bottomRight,
                    icon: Icon(Icons.keyboard_arrow_down,color: Colors.white,),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        alignment: Alignment.centerRight,
                        value: items,
                        child: MyText(txt:items,size: 12,color:Colors.white,),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if(newValue!=dropdownvalue)
                        {
                          if(newValue=='تحت الطلب')
                            {
                              paymentController.changeStatus(status: 0);
                            }
                          else
                            {
                              paymentController.changeStatus(status: 1);//تم الطلب
                            }
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        }
                    },
                  ),
                ],
              ),
            ),
            body:paymentController.bills.length>0?
            MyStaggeredList(
              listController:listController ,
              widgets: [
                SizedBox(height: 30,),
                for(int i=0;i<paymentController.bills.length;i++)
                Properties_Button(bill: paymentController.bills[i]),
                if(_paymentController.startPagnition==true)
                  Center(child: CircularProgressIndicator()),
                if(_paymentController.startPagnition==true)
                  SizedBox(height: 10,),
              ],
            ):
            paymentController.isLoad?Center(child: CircularProgressIndicator(),):
                paymentController.connectionError?InkWell(child: Center(child:Icon(Icons.refresh,size: 30,color: Colors.blue,),),onTap: (){
                  paymentController.fetch();
                },):
            Column(mainAxisAlignment: MainAxisAlignment.center,children: [Center(child: Icon(Icons.payment_outlined,color: Colors.grey,),),
              Center(child: MyText(txt: "ليست هناك مشتريات",color: Colors.grey,),)],),
          );
        }
      ),
    );
  }
}
