import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class HelperFunctions
{
  static Future<void>  makePhoneCall(String phoneNumber) async {
    bool flag=false;
    await canLaunchUrl(Uri(scheme: 'tel', path: phoneNumber)).then((bool result) {
      flag=result;
    });
    if(flag)
    {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }
  }

  static Future<void>  openWhatsAppChat(phoneNumber) async {
    String whatsappURlAndroid = "whatsapp://send?phone=$phoneNumber&text=السلام عليكم";
    String whatsappURLIos =
        "https://wa.me/$phoneNumber?text=${Uri.parse("السلام عليكم")}";
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(whatsappURLIos));
      } else {
        print("you can not call whatsapp application");
      }
    } else {
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        print("you can not call whatsapp application");
      }
    }
  }
  static Future<void>  openWebSite(url) async {
    if (Platform.isIOS || Platform.isAndroid) {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        print("you can not call whatsapp application");
      }
    }
  }
  static Future<void>  openGoogleMap(String? location) async {
    final arabicNumberPattern = RegExp(r'[٠١٢٣٤٥٦٧٨٩]+');
    bool arabicChecker= arabicNumberPattern.hasMatch( location!);//لان المستخدم احيانا يكون مفعل اللغة العربية عند اخذ موقع من الخريطة
    List<String> substrings;
    if(arabicChecker==true)
      {
        location = location.replaceAll('٠', '0');
        location = location.replaceAll('١', '1');
        location = location.replaceAll('٢', '2');
        location = location.replaceAll('٣', '3');
        location = location.replaceAll('٤', '4');
        location = location.replaceAll('٥', '5');
        location = location.replaceAll('٦', '6');
        location = location.replaceAll('٧', '7');
        location = location.replaceAll('٨', '8');
        location = location.replaceAll('٩', '9');
        location = location.replaceAll('،',',');
        List<String> chars = location.split('');
        for(int i=0;i<chars.length;i++)
          {
            if(chars[i]!='0' && chars[i]!='1' && chars[i]!='2' && chars[i]!='3' && chars[i]!='4'
                && chars[i]!='5'&& chars[i]!='6'
                && chars[i]!='7' &&chars[i]!='8'
                && chars[i]!='9' &&chars[i]!=',' &&chars[i]!=' ')
              {
                chars[i]='.';
              }
          }
         location = chars.join('');
        substrings = location.split(',');
        print(location);

      }
    else
      {
         substrings = location.split(',');

      }
    String googleMapURLIos =
        "https://maps.google.com/maps?q=${substrings[0].trim()},${substrings[1].trim()}";
    if (Platform.isIOS || Platform.isAndroid) {
      if (await canLaunchUrl(Uri.parse(googleMapURLIos))) {
        await launchUrl(Uri.parse(googleMapURLIos));
      } else {
        print("you can not call whatsapp application");
      }
    }
  }
}