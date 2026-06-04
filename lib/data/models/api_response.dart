
class ApiResponse {

  int? code;
  String? message;
  String? status;
  dynamic success;
  dynamic body;
  String? errors;


  ApiResponse({
    this.status,
    this.code,
    this.message,
    this.body,
    this.errors
  });

  List get data => body["data"];

  List get listData => body;

  List get listWithoutDataKey => body;

  int get totalDataCount => body["meta"]["total"];

  int get totalPageCount => body["meta"]["total"];

  Map? get mappedData => body["data"];

  Map? get mappedObjects => body;


  bool? get allGood => code! >= 200 && code! <= 300 ;

  bool? get noBody => errors?.isEmpty;


  /// Flattens DRF-style field validation errors into a single readable string.
  /// Only the VALUES are shown — keys are omitted because they change between
  /// endpoints and aren't useful to the end user.
  /// e.g. {"email": ["already exists"], "name": ["required"]}
  ///   → "already exists\nrequired"
  static String _flattenFieldErrors(Map body) {
    final parts = <String>[];
    body.forEach((key, value) {
      String msg;
      if (value is List && value.isNotEmpty) {
        msg = value.first?.toString() ?? '';
      } else {
        msg = value?.toString() ?? '';
      }
      if (msg.isNotEmpty) parts.add(msg);
    });
    return parts.join('\n');
  }

  factory ApiResponse.parse(response) {
    if (response != null) {
      int? code = response.statusCode;
      dynamic body = response.data;
      String? errors = "";
      String? message = "";
      String? status  = "";
      switch(code) {
        case 200:
          if (body is String) {
            message = body;
          } else if (body is List) {
            message = "Success";
          } else if (body is Map) {
            // Some APIs return 200 with an error body (e.g. {"error":"Wrong Credentials"})
            if (body.containsKey("error") && !body.containsKey("token") && !body.containsKey("user")) {
              errors = body["error"]?.toString();
              message = errors;
              code = 400;
            } else if (body.containsKey("data")) {
              if (body["data"] is Map) {
                message = body["data"]["message"];
              }
            } else {
              message = body["message"];
            }
          }
          break;
        case 201:
          if (body is String) {
            message = body;
          } else if (body is Map) {
            // Same guard for 201
            if (body.containsKey("error") && !body.containsKey("token") && !body.containsKey("user")) {
              errors = body["error"]?.toString();
              message = errors;
              code = 400;
            } else if (body.containsKey("message")) {
              message = body['message'];
            } else if (body.containsKey("data") && body["data"] is Map) {
              message = body["data"]["message"];
            } else {
              message = body['message'];
            }
          }
          break;
        case 204:
          message = "Operation successful";
          break;
        case 401:
          if(body["error"] != null) {
            errors = body["error"];
          } {}
          if(body["error"] == null) {
            errors = body["message"];
            //when the token returns invalid, clear the data
          }
          message = errors;
          break;
        case 403:
          if (body["data"] == null ) {
            errors = (body["message"]);
            if (body['message'] == null) {
              errors = body['error'];
            }
          } else {
            errors = (body["data"]["message"]);
            message = errors;
          }
          break;
        case 400:
          if (body is List) {
            message = body[0]?.toString();
          } else if (body is Map) {
            if (body.containsKey("detail")) {
              // DRF generic detail error
              errors = body["detail"]?.toString();
            } else if (body.containsKey("non_field_errors")) {
              final v = body["non_field_errors"];
              errors = v is List ? v.first?.toString() : v?.toString();
            } else if (body.containsKey("error")) {
              errors = body["error"]?.toString();
            } else if (body.containsKey("message")) {
              errors = body["message"]?.toString();
            } else if (body.containsKey("data") && body["data"] is Map &&
                body["data"]["message"] != null) {
              errors = body["data"]["message"]?.toString();
            } else {
              // DRF field-level validation errors: {"email": ["msg"], "name": ["msg"]}
              errors = _flattenFieldErrors(body);
            }
            message = errors;
          }
          break;
        case 404:
          if (body["message"] != null) {
            message = body["message"];
          } else {
            message = "Not found";
          }
          errors = (message);
          break;
        case 500:
          message = "Something went wrong, please contact support.";
          errors = (message);
          break;
        default:
          message = "Unknown application error.";
          errors = (message);
          break;
      }
      return ApiResponse(
        code: code,
        message: message,
        body: code == 204
            ? null
            : body is String
            ? null
            : body,
        errors: errors,
      );
    }else {
      return ApiResponse(
          code: 500,
          message: "Something went wrong. Please try again"
      );
    }
  }
}