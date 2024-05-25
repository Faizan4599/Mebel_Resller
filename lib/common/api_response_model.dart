import 'package:reseller_app/common/outer_response.dart';

class ApiResponseModel {
  final OuterReponse outerReponse;
  final dynamic responseData;
  ApiResponseModel({required this.outerReponse, required this.responseData});
}
