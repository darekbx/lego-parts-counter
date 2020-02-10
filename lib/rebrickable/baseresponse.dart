import 'package:lego_parts_counter/rebrickable/model/set.dart';

abstract class BaseResponse<T> {

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    if (T == int) {
      return Set.fromJson(json) as BaseResponse<T>;
    }
    throw UnimplementedError();
  }
}