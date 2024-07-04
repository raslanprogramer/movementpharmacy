import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/admin/product_screens/product_screen_controller.dart';
import 'package:movementfarmacy/static/my_urls.dart';

import '../../models/product.dart';
import '../../static/fonts.dart';
import '../../views/cart/cart.dart';
import '../../views/widgets/MyText.dart';
import '../../views/widgets/customImage.dart';
class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductScreenController _productScreenController=Get.find();
  @override
  Widget build(BuildContext context) {
    return Directionality(
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
                  txt: "المنتجات",
                  color:Colors.white,
                ),
              )),
              SizedBox(
                width: 40,
                height: 40),
            ],
          ),
        ),
      body: GetBuilder<ProductScreenController>(
        builder: (proScreenCtrl) {
          return proScreenCtrl.products.isNotEmpty? ListView.builder(
            itemCount: proScreenCtrl.products.length,
            itemBuilder: (context, index) {
              print(index.toString());
              return Card(
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      height: 70,
                      width: 70,
                      child: CustomImage(
                        image:"${MyUrls.imgUrl}${proScreenCtrl.products[index].img!}",
                        radius: 0.0,isShadow: false,fit: BoxFit.cover,),
                    ),
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                txt: proScreenCtrl.products[index].name,
                                family: Fonts.medium,
                                size: 15,
                              ),
                              MyText(
                                txt:proScreenCtrl.products[index].amount,
                                family: Fonts.medium,
                                size: 15,
                              ),
                              Row(
                                children: [
                                  MyText(
                                    txt: "${proScreenCtrl.products[index].price!} ",
                                    family: Fonts.blackOtf,
                                    size: 18,
                                    color: Colors.yellow.shade800.withOpacity(.8),
                                  ),
                                  MyText(
                                    txt: "ريال",
                                    size: 11,
                                    family: Fonts.blackTtf,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: 120,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 20.0,right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: (){
                                    proScreenCtrl.deleteCategory(index);
                                  },
                                  borderRadius: BorderRadius.circular(50) ,
                                  splashColor: Colors.grey.withOpacity(0.5),
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      child: Icon(Icons.delete,color: Colors.red,size: 22,)),
                                ),
                                InkWell(
                                  onTap: (){
                                    proScreenCtrl.updateProduct(index);
                                  },
                                  borderRadius: BorderRadius.circular(50) ,
                                  splashColor: Colors.grey.withOpacity(0.5),
                                  child: Container(
                                    width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      child: Icon(Icons.edit,color: Colors.green,size: 22,)),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              );
            },):proScreenCtrl.isLoad==true?Center(child: CircularProgressIndicator(),):
          proScreenCtrl.connectionError==true?
          InkWell(child: const Center(child: Icon(Icons.refresh,size: 30,color: Colors.blue,),),
            onTap: (){proScreenCtrl.fetch(); },):
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Icon(Icons.remove_shopping_cart_outlined,size: 50,color:  Colors.grey,),),
              Center(child: MyText(txt: "ليس هناك منتجات",color: Colors.grey,),),
            ],);
        }
      ),
        floatingActionButton: Container(
            margin: EdgeInsets.only(bottom: 20,right: 14),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(10),
            child: InkWell(child: const Icon(Icons.add,size: 40,color: Colors.white,),
              onTap: (){
                _productScreenController.saveProduct();
              },)
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
