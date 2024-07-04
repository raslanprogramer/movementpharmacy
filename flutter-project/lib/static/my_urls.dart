class MyUrls
{
  //here you have to change the URLs to your own URLs to detect with laravel project
  static String apiUrl="http://192.168.0.114:5000/api/";
  static String imgUrl="http://192.168.0.114:5000/api/images/";


  //headers for both get,post request
  static Map<String, String> postHeadersList = {
  'Content-Type': 'application/json'
  };
  static var getHeadersList={
'Content-Type': 'application/json'
  };
  static Duration timesOutInSeconds=const Duration(seconds: 15);
  //هذا الرأس هو الاهم عند استخدام سرفر لل api
  //{ 'Content-Type': 'application/json'}
  static int userCountry=0;
  static String userPhone="";
  static String userPassword="";
  static String userLocation="";
  static String adminPhone="";
  static String appVersion="1";
  static int userStoreId=1;



  //خاص بحستبات ال admins
  static String adminControllerPhone="12345678";
  static String adminPassword="";
  static String adminPosition="";

  static int adminCountry=0;

}