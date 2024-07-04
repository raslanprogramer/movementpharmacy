class Category
{
  Category({this.icon, this.name});
  Category.fromJson(Map<String,dynamic> map)
  {
    this.name = map['name'];
    this.icon = map['img'];
    this.id = map['id'];
  }
  String? icon;
  String? name;
  int? id;

  Map<String,dynamic> toJson()
  {
    return {
      "name":this.name,
      "img":this.icon,
      "id":this.id
    };
  }
}