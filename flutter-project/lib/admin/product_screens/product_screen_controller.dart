import 'dart:convert';

import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movementfarmacy/admin/categories/category_screen_controller.dart';
import 'package:movementfarmacy/models/category.dart';
import 'package:movementfarmacy/models/product.dart';
import 'package:movementfarmacy/views/widgets/MyText.dart';
import 'package:movementfarmacy/views/widgets/customImage.dart';
import '../../static/my_urls.dart';
import '../../theme/AppColor.dart';
import '../../views/widgets/custom_dialog.dart';
class ProductScreenController extends GetxController
{
  ProductScreenController({required this.categoryId});
  final int categoryId;
  List<Product> products=[];
  bool connectionError=false;
  bool isLoad=false;
   fetch()async
  {
    if(isLoad==false)
    {
      try {
        isLoad=true;
        update();//من أجل نظهر الدوران قيد التحميل
        final response = await http.get(
          Uri.parse('${MyUrls.apiUrl}product/$categoryId'),
          headers: MyUrls.getHeadersList
        ).timeout(Duration(seconds: 6));
        print("i am in CategoryController in fetch function ,${response.statusCode.toString()}");
        if (response.statusCode == 200) {
          // final data = utf8.decode(response.bodyBytes);
          final element = jsonDecode(response.body);
          print(element);
          for(var cat in element['data'])
          {
            products.add(Product.fromJson(cat));
          }
          isLoad=false;
          connectionError=false;
          update();/////////////
        }
        else {
          final element = jsonDecode(response.body);
          CustomDialog.showImageAlertDialog(
              title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
              img: "images/no-wifi.png", //successful dialog image
              buttonText: "حاول مجددا",
              onPressed: () {
                fetch();
                Get.back();
              }
          );
          isLoad=false;
          connectionError=true;
          update();/////////////
        }
      }catch (e) {
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"تأكد من اتصال الانترنت",size: 15,),),
            img: "images/no-wifi.png", //successful dialog image
            buttonText: "حاول مجددا",
            onPressed: () {
              fetch();
              Get.back();
            }
        );
        isLoad=false;
        connectionError=true;
        update();/////////////

      }
    }
  }
  storeOrUpdate(Product temp,String chose)async
  {
    print("i am in storeOrUpdate");
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(50.0))),
        insetPadding: EdgeInsets.symmetric(horizontal: Get.width/2-30),
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircularProgressIndicator(color: Colors.green,),
          ),
        ),
      ),
    );

    try{
      String insertOrUpdate;
      if(chose=="save")
      {
        insertOrUpdate="insert/product";
      }
      else
      {
        insertOrUpdate="update/product";
      }

      var request = http.MultipartRequest('POST', Uri.parse('${MyUrls.apiUrl}$insertOrUpdate'));
      // Create a multipart file from the image file
      if( selectedImage!=null)
      {

        var image = await http.MultipartFile.fromPath("img", selectedImage!.path);
        request.files.add(image);
      }
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers.addAll(MyUrls.postHeadersList);//this we will delete when we find respect host serevr
      // Set the body
      print(temp.toJson());
      request.fields['phone'] = MyUrls.adminControllerPhone;
      request.fields['password'] =MyUrls.adminPassword;
      request.fields['country'] = MyUrls.adminCountry.toString();
      request.fields['name'] = temp.name!;
      request.fields['amount'] = temp.amount!;
      request.fields['category_id'] = temp.categoryId!.toString();
      request.fields['price'] = temp.price!.toString();

      if(chose=="update")
        {
          request.fields['product_id'] = temp.id.toString();
        }





      final response=await request.send();
      print("hello=> ${response.statusCode.toString()}");
      if(response.statusCode==201)
      {

         getBack();
         getBack();

        CustomDialog.showImageAlertDialog(
            title:const MyText(txt: "تمت العملية بنجاح",),
            img: "images/tick.png", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        if(chose=="update")
          {
            products.clear();
            fetch();
            // Future.delayed(Duration(seconds: 1)).then((value)
            // {
            // });
          }
        else
          {
            products.add(Product.fromJson(jsonResponse['data']));
            update();
          }
      }
      else
      {
        getBack();
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        CustomDialog.showImageAlertDialog(
            title: MyText(txt: "${jsonResponse['message']}",),
            img: "images/error_message.jpg", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );
        // var jsonResponse = jsonDecode(responseBody);
        // print(jsonResponse.toString());
      }
    }catch(e)
    {
      getBack();
      CustomDialog.showImageAlertDialog(
          title: MyText(txt: "تحقق من اتصال الانترنت",),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
    }


  }
  //insert new product to the current category
  saveProduct()
  {
    selectedImage=null;
    GlobalKey<FormState> formKey=GlobalKey<FormState>();
    TextEditingController price=TextEditingController();
    Product product=Product(
        categoryId: categoryId
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
              child: GetBuilder<ProductScreenController>(
                  builder: (_) {
                    return SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [

                            selectedImage != null
                                ? Center(child: Image.file(selectedImage!,height: 100,width: 100,))
                                : Container(width: 100,height: 100,color: Colors.grey.shade400,alignment: Alignment.center,child: FittedBox(child: MyText(txt: "عليك اختيار صورة",textAlign: TextAlign.center,color: Colors.red,),)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                minLines: 2,
                                maxLines: 2,
                                onChanged: (value){
                                  product.name=value;
                                },
                                validator: (value){
                                  if(value==null || value.isEmpty)
                                  {
                                    return 'يجب أن لا يكون فارغا';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "اسم المنتج",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                // minLines: 2,
                                // maxLines: 2,
                                onChanged: (value){
                                  product.amount=value;
                                },
                                validator: (value){
                                  if(value==null || value.isEmpty)
                                  {
                                    return 'يجب أن لا يكون فارغا';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "الكمية:مثل 24 قرص",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                // minLines: 2,
                                controller: price,
                                keyboardType: TextInputType.number,
                                validator: (value){
                                  if(value==null || value.isEmpty)
                                  {
                                    return 'يجب أن لا يكون فارغا';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "السعر",
                                ),
                              ),
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              onTap:(){
                                pickImage();
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                height: 40,
                                width: 180,
                                decoration: BoxDecoration(
                                  color:   const Color(0xFF0BB000),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Center(
                                  child: FittedBox(
                                    child: MyText(
                                      txt: "اختر صورة",
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap:(){
                                if(formKey.currentState!.validate()&&selectedImage!=null)
                                {
                                  try{
                                    product.price=double.tryParse(price.text);
                                    storeOrUpdate(product,"save");
                                  }catch(_){

                                  }
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                height: 40,
                                decoration: BoxDecoration(
                                  color:   const Color(0xFF0BB000),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Center(
                                  child: FittedBox(
                                    child: MyText(
                                      txt: "حفظ",
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  }
              ),
            )
        ));

  }


  updateProduct(int index)
  {
    selectedImage=null;
    CategoryScreenController categoryScreenController=Get.find();
    List<String> items = [];
    Category dropCategory = categoryScreenController.categories.firstWhere((element) => element.id==products[index].categoryId);
    GlobalKey<FormState> formKey=GlobalKey<FormState>();
    TextEditingController price=TextEditingController();
    price.text=products[index].price.toString();
    Product product=Product(
        categoryId: categoryId,
       name: products[index].name,
      id: products[index].id,
      amount: products[index].amount,
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
              child: GetBuilder<ProductScreenController>(
                  builder: (_) {
                    if(products.length>0) {
                      return SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [

                            selectedImage != null
                                ? Center(child: Image.file(selectedImage!,height: 100,width: 100,))
                                :CustomImage(image: "${MyUrls.imgUrl}${products[index].img}",isNetwork: true,radius: 0,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                minLines: 2,
                                maxLines: 2,
                                initialValue: products[index].name??'',
                                onChanged: (value){
                                  product.name=value;
                                },
                                validator: (value){
                                  if(value==null || value.isEmpty)
                                  {
                                    return 'يجب أن لا يكون فارغا';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: "اسم المنتج",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                initialValue: products[index].amount??'',
                                onChanged: (value){
                                  product.amount=value;
                                },
                                validator: (value){
                                  if(value==null || value.isEmpty)
                                  {
                                    return 'يجب أن لا يكون فارغا';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "الكمية:مثل 24 قرص",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                // minLines: 2,
                                // initialValue: products[index].price.toString()??'',
                                controller: price,
                                keyboardType: TextInputType.number,
                                validator: (value){
                                  if(value==null || value.isEmpty)
                                  {
                                    return 'يجب أن لا يكون فارغا';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "السعر",
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),child: Text( "الفئة :",),),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20.0),
                                  child:  DropdownButton(
                                    // underline: Divider(color: Colors.white,),
                                    value: dropCategory.name,
                                    alignment: Alignment.bottomRight,
                                    icon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                                    items: categoryScreenController.categories.map((Category item) {
                                      return DropdownMenuItem(
                                        alignment: Alignment.centerRight,
                                        value: item.name,
                                        child: MyText(txt:item.name,size: 12,color:Colors.black,),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if(newValue!=dropCategory.name)
                                      {
                                       dropCategory=categoryScreenController.categories.firstWhere((element) => element.name==newValue);
                                        update();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              onTap:(){
                                pickImage();
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                height: 40,
                                width: 180,
                                decoration: BoxDecoration(
                                  color:   const Color(0xFF0BB000),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Center(
                                  child: FittedBox(
                                    child: MyText(
                                      txt: "اختر صورة",
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap:(){
                                if(formKey.currentState!.validate())
                                {
                                  try{
                                    product.price=double.tryParse(price.text);
                                    product.categoryId=dropCategory.id;
                                    storeOrUpdate(product,"update");
                                  }catch(_){

                                  }
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                height: 40,
                                decoration: BoxDecoration(
                                  color:   const Color(0xFF0BB000),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Center(
                                  child: FittedBox(
                                    child: MyText(
                                      txt: "حفظ",
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                    } else
                      {
                        return Container();
                      }
                  }
              ),
            )
        ));

  }
  Future deleteCategory(int index)async
  {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(50.0))),
        insetPadding: EdgeInsets.symmetric(horizontal: Get.width/2-30),
        child: const SizedBox(
          height: 60,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: CircularProgressIndicator(color: Colors.green,),
          ),
        ),
      ),
    );
    try {
      final response = await http.post(
        Uri.parse('${MyUrls.apiUrl}delete/product?phone=${MyUrls.adminControllerPhone}&password=${ MyUrls.adminPassword}&product_id=${products[index].id}'),
        headers: MyUrls.postHeadersList,
        body: jsonEncode(
            {"phone": MyUrls.adminControllerPhone, "password": MyUrls.adminPassword,"product_id":products[index].id}),
      ).timeout(MyUrls.timesOutInSeconds);
      print(response.statusCode.toString());
      if (response.statusCode == 201) {
        // final data = utf8.decode(response.bodyBytes);
        final element = jsonDecode(response.body);

        products.removeAt(index);
        getBack();
        // waitDelete=false;
        update();
        return true;
      }
      else {
        getBack();
        final element = jsonDecode(response.body);
        print(response.body.toString());
        CustomDialog.showImageAlertDialog(
            title:Padding(padding: EdgeInsets.only(top: 10),child: MyText(txt:"${element['message']}",size: 15,),),
            img: "images/error_message.jpg", //successful dialog image
            onPressed: () {
              Get.back();
            }
        );
        // waitDelete=false;
        return false;
      }
    }catch (e) {

      // waitDelete=false;
      getBack();
      print("Error:$e");
      CustomDialog.showImageAlertDialog(
          title: Text( "ليس هناك اتصال بالانترنت",),
          img: "images/no-wifi.png", //successful dialog image
          onPressed: () {
            Get.back();
          }
      );
      return false;
    }
  }
  File? selectedImage;
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      selectedImage = File(pickedImage.path);
      print(selectedImage?.path.toString());
      update();
    }
  }
   getBack()
  {
    if(Get.isDialogOpen==true)
    {
       Get.back();
    }
  }
  @override
  void onInit() {
    fetch();
    super.onInit();
  }
}