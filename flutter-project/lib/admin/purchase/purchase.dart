import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/admin/purchase/purchase_controller.dart';
import 'package:movementfarmacy/static/my_urls.dart';

import '../../theme/AppColor.dart';
import '../../views/widgets/MyText.dart';
import '../../views/widgets/Properties_Button.dart';
import 'package:flutter/cupertino.dart';
class Purchase extends StatefulWidget {
  const Purchase({Key? key}) : super(key: key);

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  String dropdownvalue ='المبيعات اليومية';

  var items = [
    'المبيعات اليومية',
    'المبيعات الشهرية',
    'المبيعات السنوية'
  ];
  DateTime? dateTime;
  String? firstDate;
  String? lastDate;
  PurchaseController _purchaseController=Get.find();
  @override
  void initState() {
    DateTime now =DateTime.timestamp();
    firstDate =  "${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)} 00:00";
    lastDate=yearToMinute(now);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                  txt: "المبيعات",
                  color:Colors.white,
                ),
              )),
              SizedBox(width: 40,height: 40,)
            ],
          ),
        ),
        body: ListView(
          children: [
            SizedBox(height: 30,),
           Column(
             children: [
               InkWell(
                 splashColor: Colors.transparent,
                 highlightColor: Colors.transparent,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.calendar_month_outlined,size: 50,color: Colors.green,),
                     SizedBox(width: 10,),
                     MyText(txt: "اختر فترة تاريخية",size: 17,),
                   ],
                 ),
               ),
               SizedBox(height: 10,),
               InkWell(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                   MyText(txt: "من تاريخ :",size: 15,),
                   SizedBox(width: 10,),
                   MyText(txt: firstDate??'............',size: 15,),
                 ],),
                 onTap: ()async{
                   dateTime= await  showDateTimePicker(
                       context: context);
                   if(dateTime!=null)
                   {
                     firstDate = "${dateTime?.year}-${_addLeadingZero(dateTime!.month)}-${_addLeadingZero(dateTime!.day)} ${_addLeadingZero(dateTime!.hour)}:${_addLeadingZero(dateTime!.minute)}";
                     print(firstDate.toString());
                     setState(() {
                     });
                   }
                 },
               ),
               SizedBox(height: 10,),
               InkWell(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                   MyText(txt:"حتى تاريخ :",size: 15,),
                   SizedBox(width: 10,),
                   MyText(txt:lastDate??'............',size: 15,),
                 ],),
                 onTap: ()async{
                   dateTime= await  showDateTimePicker(
                       context: context);
                   if(dateTime!=null) {
                     dateTime = dateTime?.add(const Duration(days: 1));
                     dateTime = dateTime?.subtract(const Duration(seconds: 5));
                     lastDate = "${dateTime?.year}-${_addLeadingZero(
                         dateTime!.month)}-${_addLeadingZero(
                         dateTime!.day)} ${_addLeadingZero(
                         dateTime!.hour)}:${_addLeadingZero(dateTime!.minute)}";
                     print(lastDate.toString());
                     setState(() {});
                   }
                 },
               ),
               SizedBox(height: 10,),
             ],
           ),
            SizedBox(height: 30,),
            InkWell(
              splashColor: AppColors.primaryGreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children:[
                  MyText(txt: "أو",),
                  SizedBox(width: 5),
                  MyText(txt: "احدى الفترات التالية",size: 11,),

                ],
              ),
              onTap: ()async{
              },
            ),
            SizedBox(height: 10,),
            Container(
              alignment: Alignment.center,
              child: DropdownButton(
                dropdownColor:Colors.white,
                underline: Divider(color: Colors.black,),
                value: dropdownvalue,
                alignment: Alignment.bottomRight,
                icon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    alignment: Alignment.centerRight,
                    value: items,
                    child: MyText(txt:items,size: 12,color:Colors.black,),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                    if(dropdownvalue==items[0])
                      {

                        DateTime now =DateTime.timestamp();
                        firstDate =  "${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)} 00:00";
                        lastDate=yearToMinute(now.subtract(Duration(hours: now.hour)).add(Duration(days: 1)));
                      }
                    else if(dropdownvalue==items[1])
                      {
                        DateTime now =DateTime.timestamp().subtract(Duration(days: 30));
                        firstDate =  "${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)} 00:00";
                        lastDate=yearToMinute(now.add(Duration(days: 30)));
                      }
                    else if(dropdownvalue==items[2])
                      {
                        DateTime now =DateTime.timestamp().subtract(Duration(days: 365));
                        firstDate =  "${now.year}-01-01 00:00";
                        lastDate=yearToMinute(now.add(Duration(days: 365)));
                      }
                  });
                },
              ),
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.primaryGreen,width: 4)
              ),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  MyText(txt: "اجمالي المبيعات في ${MyUrls.adminCountry==0?'اليمن':'السعودية'}",size: 17,),
                  SizedBox(height: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(txt: "من تاريخ :",size: 12,),
                      SizedBox(width: 10,),
                      MyText(txt: firstDate??'............',size: 12,),
                    ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(txt:"حتى تاريخ :",size: 12,),
                      SizedBox(width: 10,),
                      MyText(txt:lastDate??'............',size: 12,),
                    ],),
                  SizedBox(height: 10,),
                  GetBuilder<PurchaseController>(
                    builder: (purchaseCtrl) {
                      return MyText(txt: purchaseCtrl.totalPrice==null?'فارغ..':"${purchaseCtrl.totalPrice}ربال ",size: 18,color: Colors.red,);
                    }
                  ),
                  SizedBox(height: 20,),
              ],

              ),
            ),
            InkWell(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.calendar_month_sharp,color: AppColors.primaryGreen,size: 30,),
              SizedBox(width: 5,),
              MyText(txt: "استعلام",)
            ],),
              onTap: (){
              /////////////
                _purchaseController.betweenToDatesRequest(firstDate,lastDate);
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.timestamp();
    // initialDate=initialDate.subtract(const Duration(days: 365*0));
    firstDate= initialDate.subtract(const Duration(days: 365*5));
    lastDate = firstDate.add(const Duration(days: 365 * 10));

    final DateTime? selectedDate = await showDatePicker(
      barrierLabel: "اختيار تاريخ",
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    // final TimeOfDay? selectedTime = await showTimePicker(
    //   context: context,
    //   initialTime: TimeOfDay.fromDateTime(selectedDate),
    // );

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day
    );
  }
  String _addLeadingZero(int number) {
    if (number < 10) {
      return '0$number';
    }
    return number.toString();
  }
  String yearToMinute(DateTime now)
  {
   return "${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)} ${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}";
  }

}
