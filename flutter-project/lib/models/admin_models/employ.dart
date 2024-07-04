class Employ
{
  Employ({this.id,this.phone,this.password,this.position});
  Employ.fromJson(Map<String,dynamic> map)
  {
    print("i am in Employ constructeor in frist");
    id=map['id'].toString();
    phone=map['phone'];
    position=map['rolls_id']==1?'admin':map['rolls_id']==2?'مشرف بالدولة':map['rolls_id']==3?'موصل طلبات':'';
    password=map['password'].toString();
    name=map['name'];
    country=map['country']==0?'اليمن':map['country']==1?'السعودية':'';
    print("i am in Employ constructeor in end");

  }
  String? id;
  String? name;
  String? phone;
  String? position;
  String? password;
  String? country;
}