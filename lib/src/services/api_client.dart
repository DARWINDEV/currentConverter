import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final Uri currencyURL = Uri.https('free.currconv.com', '/api/v7/currencies',
      {'apiKey': '7f92d9dd74ddac168b5c'});

  Future<List<String>> getCurrencies() async {
    http.Response res = await http.get(currencyURL);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      var list = body['results'];
      List<String> currencies = (list.keys).toList();
      return currencies;
    } else {
      throw Exception('Failed to connect to API');
    }
  }

  //cambiamos la moneda
  Future<double> getRate(String from, String to) async {
    final Uri rateUrl = Uri.https('free.currconv.com', '/api/v7/convert',
        {'apiKey': '7f92d9dd74ddac168b5c',
          'q' : "${from}_${to}",
          'compact' : 'ultra'
        });
        http.Response res = await http.get(rateUrl);
        if(res.statusCode == 200){
          var body = jsonDecode(res.body);
          return body["${from}_${to}"];
        }else{
          throw Exception('Failed to coonect to API');
        }
  }
}
