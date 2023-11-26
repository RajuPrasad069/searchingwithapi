import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:searchlist_with_api/Uselmodel.dart';

class FetchUserList {
  var data = [];
  List<Usermodel> results = [];
  String urlList = 'https://jsonplaceholder.typicode.com/users/';

  Future<List<Usermodel>> getuser({String? query}) async {
    var url = Uri.parse(urlList);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {

        data = json.decode(response.body);
        results = data.map((e) => Usermodel.fromJson(e)).toList();
        if (query!= null){
          results = results.where((element) => element.name!.toLowerCase().contains((query.toLowerCase()))).toList();
        }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}
