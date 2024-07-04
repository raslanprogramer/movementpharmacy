import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movementfarmacy/static/fonts.dart';
import 'package:movementfarmacy/static/my_urls.dart';
import 'package:movementfarmacy/views/cart/cart.dart';
import 'package:movementfarmacy/views/widgets/MyText.dart';
import 'package:movementfarmacy/views/widgets/customImage.dart';
import 'package:movementfarmacy/views/widgets/custom_dialog.dart';
import 'package:movementfarmacy/views/widgets/my_staggered_list.dart';

import '../cart/cart_controller.dart';
import 'drags_controller.dart';
class Drags extends StatefulWidget {
  const Drags({Key? key}) : super(key: key);

  @override
  State<Drags> createState() => _DragsState();
}

class _DragsState extends State<Drags> {
  bool isTaped=false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<DragsController>(
        builder: (dragsController) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor:Color(0xFF0BB000),
              shadowColor: null,
              title: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back_ios_new,color: Colors.white,),
                    ),
                  ),
                  Expanded(child:
                  Center(
                    child: MyText(
                      txt: "الأدوية",
                      color:Colors.white,
                    ),
                      // child: Text("الأدوية",
                      //   style: TextStyle(color:
                      //   Colors.white.withOpacity(.7),
                      //   fontFamily:'Black.otf' ),)

                  )),
                  Icon(Icons.arrow_forward_ios,color: Colors.transparent,)
                ],
              ),
            ),
            body: dragsController.products.length>0?MyStaggeredList(widgets: [
              for(int i=0;i<dragsController.products.length;i++)
                Card(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.0),
                        height: 70,
                        width: 70,
                        child: CustomImage(
                          image: '${MyUrls.imgUrl}${dragsController.products[i].img}',
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
                                  txt: "${dragsController.products[i].name} ",
                                  family: Fonts.medium,
                                  size: 15,
                                ),
                                MyText(
                                  txt: "${dragsController.products[i].amount}",
                                  family: Fonts.medium,
                                  size: 15,
                                ),
                                Row(
                                  children: [
                                    MyText(
                                      txt: "${dragsController.products[i].price} ",
                                      family: Fonts.medium,
                                      size: 20,
                                      color: Colors.yellow.shade800.withOpacity(.8),
                                    ),
                                    MyText(
                                      txt: "ريال",
                                      size: 12,
                                      family: Fonts.blackTtf,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                      Container(
                        alignment: Alignment.center,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (){
                            setState(() {
                              dragsController.isTaped[i]=true;
                              isTaped=true;
                            });
                          },
                          child:dragsController.isTaped[i]==false? Container(
                            decoration:BoxDecoration(
                              color: Color(0xFF0BB000),
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                            ),
                            margin: EdgeInsets.only(left: 20),
                            padding: EdgeInsets.only(left: 5,right: 5,top: 2),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    child: Column(
                                      children: [
                                        MyText(
                                          txt: "إضافة",
                                          family: Fonts.blackOtf,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        MyText(
                                          txt: "للسلة",
                                          family: Fonts.blackOtf,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )
                                ),
                                Icon(Icons.shopping_cart,color: Colors.white,size: 20,)
                              ],
                            ),
                          )
                              :InkWell(
                            onTap: (){
                              setState(() {
                                dragsController.isTaped[i]=false;
                                isTaped=false;
                                for(bool check in dragsController.isTaped)
                                {
                                  if(check==true)
                                  {
                                    isTaped=true;
                                    break;
                                  }
                                }
                              });
                            },
                            child: Container(
                                width: 70,
                                height: 40,
                                decoration:BoxDecoration(
                                  // color: Color(0xFF0BB000),
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                ),
                                margin: EdgeInsets.only(left: 20),
                                padding: EdgeInsets.only(left: 5,right: 5,top: 2),
                                alignment: Alignment.center,
                                child: Icon(Icons.check_circle_rounded,color: Color(0xFF0BB000),size: 35,)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ]):
              dragsController.isLoad?Center(child:CircularProgressIndicator(),):
                  dragsController.connectionError==true?InkWell(
                    child: Center(child:Icon(Icons.refresh,size: 30,color: Colors.blue,),),
                    onTap: (){
                      dragsController.fetch();
                    },
                  ):
              Center(child:MyText(txt: "ليس هناك منتجات",),),
              bottomNavigationBar:isTaped? Container(
                margin: EdgeInsets.only(bottom: 10, right: 30, left: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                    // color: Colors.white,
                    // gradient:LinearGradient(colors: [
                    //   // Color(0xFFB1E7A8),
                    //   // Color(0xFFD4E8CF),
                    //
                    // ]
                    // ),
                    borderRadius: BorderRadius.circular(50)
                ),
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child:InkWell(
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
                            onTap: () {
                            setState(() {
                              for(int i=0;i<dragsController.isTaped.length;i++)
                              {
                                dragsController.isTaped[i]=false;
                              }
                              isTaped=false;
                            });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: MyText(
                                txt: "إلغاء",
                              ),
                            )), ),
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: ()async {
                             bool result= await dragsController.addToCart();

                              if(result==true)
                               {
                                 CustomDialog.showImageAlertDialog(
                                     img: "images/tick.png",
                                     title: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         SizedBox(
                                           width: 120,
                                           child: Container(
                                             height: 50,
                                             decoration: BoxDecoration(
                                               color: Colors.green,
                                               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                                             ),
                                             child:Icon(Icons.shopping_cart,size: 39,color: Colors.white,),
                                           ),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.only(top: 10),
                                           child: MyText(txt: "تم ترحيل المنتجات إلى السلة بنجاح",size: 15,
                                             color: Color(
                                                 0xFF4F4202),
                                             textAlign: TextAlign.center,),
                                         ),
                                       ],
                                     ),
                                     onPressed: (){
                                       Get.back();
                                     },
                                     iconHeight: 0,
                                     inkWell: Padding(
                                       padding: const EdgeInsets.only(bottom: 10,top: 5),
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                                         children: [
                                           InkWell(
                                             splashColor: Colors.transparent,
                                             highlightColor: Colors.transparent,
                                             child: Container(
                                               padding: EdgeInsets.all(8.0),
                                               child: MyText(txt: "رجوع",size: 14,color:Color(
                                                   0xFF4F4202) ,),
                                             ),
                                             onTap: (){
                                               Get.back();
                                               setState(() {
                                                 for(int i=0;i<dragsController.isTaped.length;i++)
                                                 {
                                                   dragsController.isTaped[i]=false;
                                                 }
                                                 isTaped=false;
                                               });
                                             },
                                           ),
                                           InkWell(
                                             child: Container(
                                               alignment: Alignment.center,
                                               padding: EdgeInsets.symmetric(horizontal: 10),
                                               decoration: BoxDecoration(
                                                 color: Colors.green,
                                                 borderRadius: BorderRadius.all(Radius.circular(5)),
                                               ),
                                               height: 30,
                                               child: MyText(txt: "ذهاب إلى السلة",size: 14,color: Colors.white,),
                                             ),
                                             onTap: (){

                                               Get.back();
                                               Get.off(() => Cart(),
                                                   binding: BindingsBuilder(() {
                                                     Get.put(CartController(
                                                     ));
                                                   }));
                                             },
                                           )

                                         ],
                                       ),
                                     )
                                 );
                               }
                             else
                               {
                                 CustomDialog.showImageAlertDialog(

                                     img: "images/tick.png",
                                     title: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         SizedBox(
                                           width: 120,
                                           child: Container(
                                             height: 50,
                                             decoration: BoxDecoration(
                                               color: Colors.green,
                                               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                                             ),
                                             child:Icon(Icons.shopping_cart,size: 39,color: Colors.white,),
                                           ),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.only(top: 10),
                                           child: MyText(txt: "هناك خطأ، لم يتم ترحيل المنتجات بنجاح",size: 15,
                                             color: Color(
                                                 0xFF4F4202),
                                             textAlign: TextAlign.center,),
                                         ),
                                       ],
                                     ),
                                     onPressed: (){
                                       Get.back();
                                     },
                                     iconHeight: 0,
                                     inkWell: Padding(
                                       padding: const EdgeInsets.only(bottom: 10,top: 5),
                                       child: Container(),
                                     )
                                 );
                               }

                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart(),));
                            },
                            child:Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xFF0BB000),
                                  borderRadius: BorderRadius.horizontal(left: Radius.circular(50))),
                              child:
                              MyText(txt: "ترحيل للسلة", fontweight: FontWeight.bold, size: 16,color: Colors.white,),
                            )
                        )),
                  ],
                ),
              ):null
          );
        }
      ),
    );
  }
}
