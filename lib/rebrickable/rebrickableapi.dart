import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'baseresponse.dart';
import 'package:lego_parts_counter/rebrickable/model/set.dart';
import 'package:lego_parts_counter/rebrickable/model/setpart.dart';

class RebrickableApi {

  final String BASE_URL = "https://rebrickable.com/api/v3/lego/";
  final int PAGE_SIZE = 100;

  String apiKey;

  RebrickableApi(this.apiKey);

  Future<BaseResponse<Set>> sets(String query, int page) async {
    var url = "$BASE_URL/sets?page=$page&page_size=$PAGE_SIZE&search=$query";
    var response = await http.get(url, headers: _headers());
    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      var sets = (jsonBody["results"] as List).map((item) => Set.fromJson(item));
      return BaseResponse<Set>(jsonBody["count"] as int, sets.toList());
    } else {
      throw HttpException("Exception code ${response.statusCode}");
    }
  }

  Future<BaseResponse<SetPart>> setParts(String setNum, int page) async {
    var url = "$BASE_URL/sets/$setNum/parts/?page=$page&page_size=$PAGE_SIZE";
    var response = await http.get(url, headers: _headers());
    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      var setParts = (jsonBody["results"] as List).map((item) => SetPart.fromJson(item));
      return BaseResponse<SetPart>(jsonBody["count"] as int, setParts.toList());
    } else {
      throw HttpException("Exception code ${response.statusCode}");
    }
  }

  Map<String, String> _headers() {
    return { "Authorization": "key $apiKey" } as Map;
  }
}