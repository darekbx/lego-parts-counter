import 'package:lego_parts_counter/rebrickable/baseresponse.dart';

class PagedWrapper<T extends BaseResponse> {

  int count;
  List<T> results;

  PagedWrapper(this.count, this.results);

  PagedWrapper.fromJson(Map<String, dynamic> json)
      : count = json["count"],
        results = (json["results"] as List).map((item) =>
            BaseResponse.fromJson(item)).toList();
}