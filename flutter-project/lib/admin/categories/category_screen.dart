import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/admin/categories/category_screen_controller.dart';
import 'package:movementfarmacy/admin/product_screens/product_screen_controller.dart';
import 'package:movementfarmacy/admin/product_screens/products_Screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movementfarmacy/static/my_urls.dart';
import '../../models/category.dart';
import '../../static/fonts.dart';
import '../../views/home/main_home.dart';
import '../../views/widgets/MyText.dart';
import '../../views/widgets/customImage.dart';
import 'dart:io';
class CategoryScreen extends StatefulWidget {
   CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
   bool flag=false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<CategoryScreenController>(
        init: CategoryScreenController(),
        builder: (cateScreenCtrl) {
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
                      txt: "الفئات",
                      color:Colors.white,
                    ),
                  )),
                  InkWell(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child:flag?Icon(Icons.close,color: Colors.white,): Icon(Icons.edit,color: Colors.white,),
                    ),
                    onTap: (){
                      setState(() {
                        flag=!flag;
                      });
                    },
                  ),
                ],
              ),
            ),
            body:cateScreenCtrl.categories.isNotEmpty? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      runSpacing: 20,
                      spacing: 10,
                      children: [
                        for(int i=0;i<cateScreenCtrl.categories.length;i++)
                          Container(
                            width: 100,
                            child: Column(
                              children: [
                                if(flag==true)
                                PopupMenuButton(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    padding: EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft:Radius.circular(10) )
                                    ),
                                    child:  Icon(
                                      Icons.more_vert, color: Colors.white, size: 25,),
                                  ),
                                  color: Colors.white,
                                  position: PopupMenuPosition.under,
                                  itemBuilder: (context) =>
                                  [

                                    PopupMenuItem(
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        onTap: () async {
                                          cateScreenCtrl.deleteCategory(i);
                                        }, value: 2,
                                        child:ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                          title:MyText(txt: "حذف",
                                            textAlign: TextAlign.center,
                                            size: 12,
                                            color: Colors.black,) ,
                                          leading: Icon(Icons.delete,color: Colors.red,),
                                        )),
                                    PopupMenuItem(
                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                        onTap: () async {
                                          cateScreenCtrl.updateCategory(i);
                                        }, value: 2,
                                        child:ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                          title:MyText(txt: "تعديل",
                                            textAlign: TextAlign.center,
                                            size: 12,
                                            color: Colors.black,) ,
                                          leading: Icon(Icons.delete,color: Color(0xFF0BB000),),
                                        )),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() =>const ProductScreen(),
                                        binding: BindingsBuilder(() {
                                          Get.put(ProductScreenController(
                                              categoryId: cateScreenCtrl.categories[i].id!
                                          ));
                                        }));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      // color: Colors.green,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        CustomImage(
                                          borderRadius: BorderRadius.circular(5),
                                          isNetwork: true,
                                          width: 80,
                                          height: 80,
                                          image: '${MyUrls.imgUrl}${cateScreenCtrl.categories[i].icon}',
                                          radius: 0.0,
                                          isShadow: false,
                                          fit: BoxFit.cover,),
                                        Container(
                                          padding:EdgeInsets.symmetric(horizontal: 5) ,
                                          child:  MyText(
                                            txt:cateScreenCtrl.categories[i].name,size: 16,family: Fonts.medium, textAlign: TextAlign.center,),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 85,),
                ],
              ),
            ):cateScreenCtrl.isLoad==true?Center(child: CircularProgressIndicator(),):
            cateScreenCtrl.connectionError==true?
            InkWell(child: const Center(child: Icon(Icons.refresh,size: 30,color: Colors.blue,),),
              onTap: (){cateScreenCtrl.fetch(); },):
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Icon(Icons.remove_shopping_cart_outlined,size: 50,color:  Colors.grey,),),
                Center(child: MyText(txt: "ليس هناك فئات",color: Colors.grey,),),
              ],),
            floatingActionButton: Container(
                margin: EdgeInsets.only(bottom: 20,right: 14),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.all(10),
                child: InkWell(child: Icon(Icons.add,size: 40,color: Colors.white,),
                onTap: (){
                  cateScreenCtrl.saveCategory();
                },)
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          );
        }
      ),
    );
  }


}
