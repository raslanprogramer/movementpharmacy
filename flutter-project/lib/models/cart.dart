import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movementfarmacy/models/product.dart';
import 'package:movementfarmacy/static/my_urls.dart';

class Cart {
  Cart.fromJson(Map<String, dynamic> map){
    for (var product in map['data']) {
      products.add(Product.fromJson(product['product']));
    }
  }

  List<Product> products = [];

  Future update(String addOrMinus, int? productId) async
  {
    try {
      final response = await http.post(
        Uri.parse('${MyUrls.apiUrl}store/5/update?'),
        // headers: Static_Var.headersWithoutType,
        body: jsonEncode(
            {'product': productId, 'label': addOrMinus}),
        // headers: Static_Var.headers
      );
      print(response.statusCode.toString());
      if (response.statusCode == 201 || response.statusCode == 200) {
        // final data = utf8.decode(response.bodyBytes);
        final element = jsonDecode(response.body);
        print(element);
        return element;
      }
      else {
        final element = jsonDecode(response.body);
        print(element);
        return element;
      }
    } on SocketException catch (e) {
      print("Socket Error:$e");
    } on Error catch (e) {
      print("Error:$e");
    }
  }
}