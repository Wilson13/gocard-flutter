class AppException implements Exception {
  final _message;
  // String _prefix;
  
AppException([this._message]);//, this._prefix]);
  
String toString() {
  // _prefix = _prefix == null ? "" : _prefix;
    // return "$_prefix$_message";
    return _message;
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message]): super(message);
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message);
}

class NotFoundException extends AppException {
  NotFoundException([message]) : super(message);
}

class ConflictException extends AppException {
  ConflictException([message]) : super(message);
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message);
}