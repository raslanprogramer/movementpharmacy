import 'package:flutter/material.dart';
import 'package:movementfarmacy/admin/employes/employes_controller.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/static/helper_fuctions.dart';
import 'package:movementfarmacy/theme/AppColor.dart';

import '../../views/widgets/MyText.dart';

class EmploysView extends StatefulWidget {
  const EmploysView({Key? key}) : super(key: key);

  @override
  State<EmploysView> createState() => _EmploysViewState();
}

class _EmploysViewState extends State<EmploysView> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<EmploysController>(
          builder: (employController) {
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
                        txt: "الموظفين",
                        color:Colors.white,
                      ),
                    )),
                    const SizedBox(
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
              body:employController.employs.isNotEmpty? ListView.separated(
                  itemBuilder:(context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child:Column(
                        children: [
                          FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                MyText(txt:'اسم الموظف :' ,size: 18,),
                                SizedBox(width: 10,),
                                MyText(txt:employController.employs[index].name,size: 18,)
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              MyText(txt:'رقم الهاتف :' ,size: 15,),
                              SizedBox(width: 10,),
                              InkWell(
                                child: MyText(txt:employController.employs[index].phone ,size: 17,color: Colors.blue,textDecoration: TextDecoration.underline,)
                              ,onTap: (){
                                  HelperFunctions.makePhoneCall(employController.employs[index].phone.toString());
                              },)
                            ],
                          ),
                          Row(
                            children: [
                              MyText(txt:'كلمة السر :' ,size: 15,),
                              SizedBox(width: 10,),
                              MyText(txt:employController.employs[index].password ,size: 15,)
                            ],
                          ),
                          Row(
                            children: [
                              MyText(txt:'الوظيفة :' ,size: 15,),
                              SizedBox(width: 10,),
                              MyText(txt:employController.employs[index].position ,size: 15,)
                            ],
                          ),
                          Row(
                            children: [
                              MyText(txt:'الدولة :' ,),
                              SizedBox(width: 10,),
                              MyText(txt:employController.employs[index].country,size: 15 ,),
                              Expanded(child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      child: Icon(Icons.edit,color: AppColors.primaryGreen,size: 27,),
                                  onTap: (){
                                    employController.dialogToUpdateStoreData(employController.employs[index]!);

                                  },),
                                  SizedBox(width: 10,),
                                  InkWell(

                                      child: Icon(Icons.delete,color: Colors.red,size: 27,),
                                  onTap: (){
                                        employController.deleteEmploy(employController.employs[index].id!);
                                  },),
                                  SizedBox(width: 5,),

                                ],
                              ))
                            ],
                          ),
                        ],
                      ),
                    );
                  }, separatorBuilder: (context, index) {
                return const SizedBox(height: 5,);
              }, itemCount: employController.employs.length)
                  :employController.isLoad?const Center(child: CircularProgressIndicator(),):employController.connectionError?InkWell(child: const Center(child: Icon(Icons.refresh,size: 30,color: Colors.blue,),),
                onTap: (){employController.fetch(); },):
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Icon(Icons.people,size: 50,color:  Colors.grey,),),
                  Center(child: MyText(txt: "ليس هناك موظفين",color: Colors.grey,),),

                ],),
            );
          }
      ),
    );

  }

}
