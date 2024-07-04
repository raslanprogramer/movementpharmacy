
class Customer
{
  Customer({this.id,this.name,this.phone,this.password,this.location,this.country,this.note});
  Customer.fromJson(Map<String,dynamic> map)
  {
    id=int.tryParse(map['id'].toString());
    name=map['name'];
    phone=map['phone'].toString();
    password=map['password'].toString();
    location=map['location'];
    note=map['note'];
    country=int.tryParse(map['country'].toString());

  }
  int? id;
  String? name;
  String? phone;
  String? password;
  String? location;
  String? note;
  int? country;
}