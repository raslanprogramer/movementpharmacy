class Advertisement
{
  Advertisement({this.id,this.img});
  Advertisement.fromJson(Map<String,dynamic> map)
  {
    id=map['id'];
    img=map['img'];
  }
  int? id;
  String? img;
}