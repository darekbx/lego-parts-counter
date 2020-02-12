
class BaseResponse<T> {

  int count;
  List<T> results;

  BaseResponse(this.count, this.results);
}