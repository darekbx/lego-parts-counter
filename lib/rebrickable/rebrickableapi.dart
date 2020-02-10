import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'baseresponse.dart';
import 'package:lego_parts_counter/rebrickable/model/pagedwrapper.dart';
import 'package:lego_parts_counter/rebrickable/model/set.dart';

class RebrickableApi {

  final String BASE_URL = "https://rebrickable.com/api/v3";
  final int PAGE_SIZE = 10;

  String apiKey;

  RebrickableApi(this.apiKey);

  Future<PagedWrapper<BaseResponse<Set>>> sets(String query) async {
    var url = "$BASE_URL/sets?page_size=$PAGE_SIZE&search=$query";
    var response = await http.get(url, headers: _headers());

    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      var result = PagedWrapper.fromJson(jsonBody);

    }
  }

  Map<String, String> _headers() {
    return { "Authorization", "key $apiKey" } as Map;
  }
}