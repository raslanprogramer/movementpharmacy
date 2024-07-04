

import 'package:movementfarmacy/models/admin_models/customer.dart';

import '../order_items.dart';

class AdminBill{
  AdminBill({this.createdAt,this.billNumber});
  AdminBill.fromJson(Map<String,dynamic> map)
  {
    createdAt=map['created_at'];
    billNumber=map['bill_id'].toString();

    //خاص بالزبون الذي قام بالعملية
    customer.name=map['name'];
    customer.phone=map['[phone]'];
    customer.note=map['note'];
    customer.location=map['location'];

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
  bool isTapedOrNot=false;//
  List<Order?> orders=[];
  Customer customer=Customer();

}
