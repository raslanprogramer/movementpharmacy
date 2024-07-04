
class Product
{
  Product({this.id,this.name,this.img,this.amount,this.price,this.country,this.categoryId});
  Product.fromJson(Map<String,dynamic> map){
    try
        {
          print("hello->>>>>>>>>>>>>>>"+map.toString());
          id=map['id'];
          name=map['name'];
          img=map['img'];
          amount=map['amount'];
          price=double.parse(map['price']);
          categoryId=map['category_id'];
        }catch(e)
    {
      print("i am in Product model in Product.fromJson error is:$e");
    }
  }
  int? id;
  String? name;
  String? img;
  String? amount;
  double? price;
  int? country;
  int? categoryId;
  Map<String,dynamic> toJson()
  {
    return {
      "id":id,
      "name":name,
      "img":img,
      "amount":amount,
      "price":price,
      "category_id":categoryId
    };
  }
}