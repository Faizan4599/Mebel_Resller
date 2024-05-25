class Success {
  int code;
  Object response;
  Success({required this.code, required this.response});
}

class Failed {
  int code;
  Object response;
  Failed({required this.code, required this.response});
}
class Failure {
  int code;
  Object errorResponse;
  Failure({required this.code, required this.errorResponse});
}

class APICode {
  static var SUCCESS = 200;
  static var SUCCESS_Login = 2001;
  static var Failed = 201;
  static var INVALID_REPONSE = 502;
  static var NO_INTERNET = 502;
  static var INVALID_FORMAT = 403;
  static var UNKNOWN_ERROR = 200;
  static var NotFound = 404;
  static var UnauthorizedPermalink = 401;
  static var BadRequest = 400;
  static var InternalServerError = 500;
}
