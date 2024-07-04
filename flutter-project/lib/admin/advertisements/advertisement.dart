import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/admin/advertisements/advertisement_controller.dart';
import 'package:movementfarmacy/static/my_urls.dart';
import 'package:movementfarmacy/views/widgets/customImage.dart';

import '../../views/widgets/MyText.dart';
class Advertisement extends StatelessWidget {
  const Advertisement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<AdvertisementController>(
        builder: (advController) {
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
                    Expanded(child:
                    Center(
                      child: MyText(
                        txt: "الاعلانات",
                        color:Colors.white,
                      ),
                    )),
                    SizedBox(
                      width: 40,
                      height: 40,),
                  ],
                ),
              ),
            body:advController.advertisements.isNotEmpty? ListView.builder(
                itemCount: advController.advertisements.length,
                itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomImage(
                      image: "${MyUrls.imgUrl}${advController.advertisements[index].img}",
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      isShadow: false,
                      radius: 15,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            advController.deleteAdv(index);
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Icon(Icons.delete,color: Colors.red,),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }):
                advController.isLoad?Center(child: CircularProgressIndicator(),):
            advController.connectionError==true?
            InkWell(child: const Center(child: Icon(Icons.refresh,size: 30,color: Colors.blue,),),
              onTap: (){advController.fetch(); },):
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Icon(Icons.remove_shopping_cart_outlined,size: 50,color:  Colors.grey,),),
                Center(child: MyText(txt:"ليس هناك اعلانات",color: Colors.grey,),),

              ],),
            floatingActionButton: InkWell(
              child: Container(
                margin: EdgeInsets.only(bottom: 20,right: 14),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.add,size: 40,color: Colors.white,)
              ),
              onTap: (){
                advController.addAdvertisement();
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          );
        }
      ),
    );
  }
}
