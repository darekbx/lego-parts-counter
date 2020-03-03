import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lego_parts_counter/rebrickable/model/color.dart';
import 'package:lego_parts_counter/rebrickable/model/part.dart';

import 'baseresponse.dart';
import 'package:lego_parts_counter/rebrickable/model/set.dart';
import 'package:lego_parts_counter/rebrickable/model/setpart.dart';

/**
 * Scenario 1:
 *   1. Search by set number (searchSets)
 *   2. Fetch set parts (fetchSetParts)
 *   3. Select part and get it's all colors (fetchPartColors)
 *   4. Select all sets by part and color (fetchPartSets)
 *
 * Scenario 2:
 *   1. Search by part number (searchPart)
 *   2. Select part and get it's all colors (fetchPartColors)
 *   3. Select all sets by part and color (fetchPartSets)
 */
class RebrickableApi {

  final String BASE_URL = "https://rebrickable.com/api/v3/lego/";
  final int PAGE_SIZE = 200;

  String apiKey;

  RebrickableApi(this.apiKey);

  Future<BaseResponse<Set>> searchSets(String query, int page) async {
    var url = "$BASE_URL/sets?page=$page&page_size=$PAGE_SIZE&search=$query";
    return _handlePagedResponse<Set>(url, (item) => Set.fromJson(item));
  }

  Future<Part> searchPart(String partNum) async {
    var url = "$BASE_URL/parts/$partNum";
    return _handleResponse(url, (body) => Part.fromJson(body));
  }

  Future<BaseResponse<SetPart>> fetchSetParts(String setNum, int page) async {
    var url = "$BASE_URL/sets/$setNum/parts/?page=$page&page_size=$PAGE_SIZE";
    return _handlePagedResponse<SetPart>(url, (item) => SetPart.fromJson(item));
  }

  Future<BaseResponse<Color>> fetchPartColors(String partNum, int page) async {
    var url = "$BASE_URL/parts/$partNum/colors/?page=$page&page_size=$PAGE_SIZE";
    return _handlePagedResponse<Color>(url, (item) => Color.fromJson(item));
  }

  Future<BaseResponse<Set>> fetchPartSets(String partNum, int color, int page) async {
    var url = "$BASE_URL/parts/$partNum/colors/$color/sets/?page=$page&page_size=$PAGE_SIZE";
    return _handlePagedResponse<Set>(url, (item) => Set.fromJson(item));
  }

  Future<T> _handleResponse<T>(String url, Function converter) async {
    var response = await http.get(url, headers: _headers());
    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      return converter(jsonBody) as T;
    } else {
      throw HttpException("Exception code ${response.statusCode}");
    }
  }

  Future<BaseResponse<T>> _handlePagedResponse<T>(String url, Function converter) async {
    var response = await http.get(url, headers: _headers());
    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      var items = (jsonBody["results"] as List).map((item) => converter(item) as T);
      return BaseResponse<T>(jsonBody["count"] as int, jsonBody["next"], items.toList());
    } else {
      throw HttpException("Exception code ${response.statusCode}");
    }
  }

  Map<String, String> _headers() {
    return { "Authorization": "key $apiKey" } as Map;
  }
}