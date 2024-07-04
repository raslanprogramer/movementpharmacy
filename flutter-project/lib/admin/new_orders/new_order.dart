import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/admin/new_orders/new_order_controller.dart';

import '../../views/widgets/MyText.dart';
import '../../views/widgets/bill_buttons.dart';
import '../../views/widgets/my_staggered_list.dart';
class NewOrder extends StatefulWidget {
  const NewOrder({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  NewOrderController _newOrderController=Get.find();
  ScrollController listController=ScrollController();
  @override
  void initState() {
    listController.addListener(() {
      if (listController.position.pixels >= listController.position.maxScrollExtent-30) {
        if(_newOrderController.isLoad==false) {
          //في حالة ما زالت البيانات تجلب فلا يجب أن نرسل طلب حتى ننتهي من الطلب الأول
          _newOrderController.fetch();
          if(_newOrderController.startPagnition==true)
          {
            //من أجل أن يظهر أداة الدوران أسفل القائمة لإخبار المستخدم ان البيانات قيد الجلب
            setState(() {
            });
          }
        }
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor:const Color(0xFF0BB000),
          shadowColor: null,
          title: Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
              ),
              Expanded(child:
              Center(
                child: MyText(
                  txt: widget.title,
                  color:Colors.white,
                ),
              )),
              SizedBox(
                width: 40,
                height: 40,),
            ],
          ),
        ),
        body: GetBuilder<NewOrderController>(
          builder: (newOrderCtrl) {
           return newOrderCtrl.bills.length>0?
            MyStaggeredList(
              listController:listController ,
              widgets: [
                SizedBox(height: 30,),
                ...List.generate(newOrderCtrl.bills.length, (index){
                  return BillButton(adminBill: newOrderCtrl.bills[index],
                  transferButton: (){
                    //هذا الزر من أجل القيام بعملية قبول الطلب وترحيله
                    newOrderCtrl.updateBill(newOrderCtrl.bills[index].billNumber);
                  },
                    cancelButton: (){
                      //هذا الزر من أجل القيام بعملية الغاء الطلب
                      newOrderCtrl.cancelBill(newOrderCtrl.bills[index].billNumber);
                    },
                    userClickButton: (){
                    //هذا الزر لعرض بيانات العميل الذي قام بتنفيذ الطلب
                    },
                  );
                }),
                //this code for pagination ,to load as need not all data at the same time
                if(newOrderCtrl.startPagnition==true)
                  Center(child: CircularProgressIndicator()),
                if(newOrderCtrl.startPagnition==true)
                  SizedBox(height: 10,),
              ],
            ):
            newOrderCtrl.isLoad?Center(child: CircularProgressIndicator(),):
            newOrderCtrl.connectionError?InkWell(child: Center(child:Icon(Icons.refresh,size: 30,color: Colors.blue,),),onTap: (){
              newOrderCtrl.fetch();
            },):
            Column(mainAxisAlignment: MainAxisAlignment.center,children: [Center(child: Icon(Icons.payment_outlined,color: Colors.grey,),),
              Center(child: MyText(txt: "ليس هناك طلبات",color: Colors.grey,),)],);
            // return ListView.separated(itemBuilder: (context, index) {
            //   return             BillButton();
            // }, separatorBuilder: (context, index) {
            //   return SizedBox(height: 10,);
            // }, itemCount: 10);
          }
        )
      ),
    );
  }
}
