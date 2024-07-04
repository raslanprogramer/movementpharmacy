import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/admin/customers/cutomers_controller.dart';
import 'package:movementfarmacy/models/admin_models/customer.dart';
import 'package:movementfarmacy/static/helper_fuctions.dart';
import 'package:movementfarmacy/theme/AppColor.dart';
import 'package:movementfarmacy/views/widgets/MyText.dart';

import '../../views/widgets/custom_dialog.dart';

class CustomersView extends StatefulWidget {
  const CustomersView({Key? key}) : super(key: key);

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  final CustomersController _customersController=Get.find();
  bool enableEdit=false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<CustomersController>(
        builder: (customersController) {
          return Scaffold(
            backgroundColor: Colors.white,
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
                  const Expanded(child:
                  Center(
                    child: MyText(
                      txt: "العملاء",
                      color:Colors.white,
                    ),
                  )),
                  InkWell(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child:enableEdit?const Icon(Icons.close,color: Colors.white,): const Icon(Icons.edit,color: Colors.white,),
                    ),
                    onTap: (){
                      setState(() {
                        enableEdit=!enableEdit;
                      });
                    },
                  ),
                ],
              ),
            ),
            body:customersController.customers.isNotEmpty? ListView.separated(
                itemBuilder:(context, index) {
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      onTap: (){
                      },
                      leading: InkWell(
                        child: const Icon(Icons.call),
                        onTap: (){
                          HelperFunctions.makePhoneCall(customersController.customers[index].phone??'');
                        },
                      ),
                      title:MyText(
                        txt:  "${customersController.customers[index].name} ",
                        size: 18,
                      ),
                      subtitle:
                      MyText(
                        txt: "معلومات اضافية: ${customersController.customers[index].note}",
                        size: 13,
                      ),
                      trailing:!enableEdit?InkWell(
                        child:  Image.asset("images/iconmap.png",width: 30,height: 30,),
                        onTap: (){
                          String? location=customersController.customers[index].location;
                          if(location!=null && location!='' && location!='null') {
                            HelperFunctions.openGoogleMap(customersController.customers[index].location);
                          }
                        },
                      ):FittedBox(
                        child: Row(
                          children: [
                            InkWell(child: Icon(Icons.edit,color: AppColors.primaryGreen,size: 27,)
                              ,onTap: (){
                                dialogToUpdateStoreData(customersController.customers[index]);
                              },),
                            SizedBox(width: 6,),
                            InkWell(child: Icon(Icons.delete,color: Colors.red,size: 27,),
                              onTap: (){
                                CustomDialog.showImageAlertDialog(
                                    title:Padding(padding: const EdgeInsets.only(top: 10),child: MyText(txt:"تحذير ! تأكد مما تقوم به فإن عملية حذف المستخدم تعطل نظام المستخدم مما يؤدي الى فقدان العملاء",size: 15,),),
                                    img: "images/error_message.jpg", //successful dialog image
                                    buttonText: "أعي ما أفعل!",
                                    onPressed: () {
                                      Get.back();
                                      customersController.deleteCustomer(customersController.customers[index].id!);
                                    }
                                );
                              },),
                          ],
                        ),
                      ),
                    ),
                  );
                }, separatorBuilder: (context, index) {
                  return const SizedBox(height: 5,);
                }, itemCount: customersController.customers.length)
            :customersController.isLoad?const Center(child: CircularProgressIndicator(),):customersController.connectionError?InkWell(child: const Center(child: Icon(Icons.refresh,size: 30,color: Colors.blue,),),
              onTap: (){customersController.fetch(); },):
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Icon(Icons.people,size: 50,color:  Colors.grey,),),
                Center(child: MyText(txt: "ليس هناك مستخدمين",color: Colors.grey,),),

              ],),
          );
        }
      ),
    );

  }
  dialogToUpdateStoreData(Customer customer)
  {
    TextEditingController name=TextEditingController();
    TextEditingController phone=TextEditingController();
    TextEditingController password=TextEditingController();
    TextEditingController location=TextEditingController();
    TextEditingController note=TextEditingController();
    final GlobalKey<FormState> formKey=GlobalKey<FormState>();
    String country=customer.country.toString();

    name.text=customer.name??'';
    phone.text=customer.phone??'';
    password.text=customer.password??'';
    location.text=customer.location??'';
    note.text=customer.note??'';

    Customer updatableCustomer=Customer(
      id: customer.id,
    );

    Get.dialog(
      Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(20.0))),
          // insetPadding: EdgeInsets.symmetric(horizontal: Get.width/6),
          child: Form(
            key:formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                    ),
                    child:  const MyText(
                      color: Colors.white,
                      size: 16,
                      txt: "تعديل بيانات المستخدم",
                    ),
                  ),
              
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: MyText(
                          size: 15,
                          txt: "الاسم: ",
                        ),
                      ),
                      SizedBox(
                          width: 150,
                          child: TextFormField(
                            controller: name,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: MyText(
                          size: 15,
                          txt: "الهاتف: ",
                        ),
                      ),
                      SizedBox(
                          width: 150,
                          child: TextFormField(
                            controller: phone,
                            validator: (value)
                            {
                              if(value==null || value.isEmpty)
                                {
                                  return 'رقم هاتف خاظئ';
                                }
                              return null;
                            },
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: MyText(
                          size: 15,
                          txt: "كلمة السر: ",
                        ),
                      ),
                      SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: password,
                            validator: (value)
                            {
                              if(value==null || value.isEmpty||value.length<4)
                              {
                                return 'ادخل اربعة على الاقل';
                              }
                              return null;
                            },
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: MyText(
                          size: 15,
                          txt: "الموقع: ",
                        ),
                      ),
                      SizedBox(
                          width: 150,
                          child: TextFormField(
                            controller: location,
                          )),
                    ],
                  ),
                  const SizedBox(height: 3,),
                  // Row(
                  //   children: [
                  //     Column(children: [
                  //       const Text("اليمن"),
                  //       RadioListTile(
                  //           value: "0", groupValue: country, onChanged: (val)
                  //       {
                  //         country=val!;
                  //       }),
                  //     ],),
                  //     Column(children: [
                  //       const Text("السعودية"),
                  //       RadioListTile(value: "1", groupValue: country, onChanged: (val)
                  //       {
                  //         country=val!;
                  //       }),
                  //     ],),
                  //
                  //   ],
                  // ),
                  const SizedBox(height: 3,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 3,
                      controller: note,
                      decoration: const InputDecoration(
                        labelText: "معلومات اضافية",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black
                            )
                        ),
                      ),
                    ),
                  ),
              
              
                  // Image.asset(img,height: iconHeight),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap:(){
                              if(formKey.currentState!.validate())
                                {
                                 updatableCustomer.name=name.text;
                                 updatableCustomer.phone=phone.text;
                                 updatableCustomer.password=password.text;
                                 updatableCustomer.country=int.tryParse(country);
                                 updatableCustomer.location=location.text;
                                 updatableCustomer.note=note.text;
                                  _customersController.updateStoreData(updatableCustomer);
                                }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10,top: 5),
                              height: 40,
                              decoration: BoxDecoration(
                                color:   const Color(0xFF0BB000),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Center(
                                child: FittedBox(
                                  child: MyText(
                                    txt: "حفظ",
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ) ),
                      Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10,top: 5,right: 5),
                            child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: const MyText(txt: "إلغاء",size: 18),
                              ),
                              onTap: (){
                                Get.back();
                              },
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(height: 10,)
                ],
              ),
            ),
          ),
        ),
      ),

    );

  }
}
