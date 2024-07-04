class Order{
  Order({this.productName,this.productPrice,this.quantity});
  Order.fromJson(Map<String,dynamic> map)
  {
    productName=map['name'];
    productPrice=double.tryParse(map['price'].toString());
    quantity=int.tryParse(map['quantity'].toString());
  }
  double? productPrice;
  String? productName;
  int? quantity;

}