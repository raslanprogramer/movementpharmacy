import 'order_items.dart';

class Bill{
  Bill({this.createdAt,this.billNumber});
  Bill.fromJson(Map<String,dynamic> map)
  {
    createdAt=map['created_at'];
    billNumber=map['id'].toString();
    //remember a bill contains products inside collection named orderitems
    for(var order in map['orderitems'])
      {
        Order temp=Order.fromJson(order);
        orders.add(temp);
        totalPrice+=temp.productPrice!*temp.quantity!;
      }
    print("i am in Bill.fromJson constructor every thing is good");

  }
  String? createdAt;
  String? billNumber;
  double totalPrice=0;
  bool isTapedOrNot=true;//
  List<Order?> orders=[];


}
