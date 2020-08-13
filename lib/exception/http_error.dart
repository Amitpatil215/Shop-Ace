class HttpException implements Exception {
// Exception is abstract class so we implementing instead of extending
  final String message;

  HttpException({this.message});

  @override
  String toString() {
    return message;
// return super.toString();  it gives "Instance of HttpException"
  }
}
