
class BaseResponse<T> {

  int count;
  String next;
  List<T> results;

  BaseResponse(this.count, this.next, this.results);
}