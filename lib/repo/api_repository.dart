import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:reseller_app/common/api_response_model.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/common/outer_response.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/landscreen/model/get_categories_data_model.dart';
import 'package:reseller_app/repo/api_urls.dart';
import 'package:reseller_app/repo/response_handler.dart';

import '../features/login/model/login_data_mode.dart';

class APIRepository {
  static var client = http.Client;
  static String statusKey = '';
  Future<dynamic> getCommonMethodAPI(
      Map<String, String> parameters, String endpoint) async {
    try {
      final String url = Constant.testMainBaseUrl + endpoint;
      Map<String, String> header = {
        HttpHeaders.contentTypeHeader: "application/json"
      };
      Uri uri = Uri.parse(url);
      final finalUri = uri.replace(queryParameters: parameters);
      print("API Url: $url");
      print("Parameters: $parameters");
      final response = await http.get(finalUri, headers: header);

      var jsonMap = json.decode(response.body);

      if (response.statusCode == 201) {
        var outerResponse = OuterReponse.fromJson(jsonMap['Response']);
        statusKey = outerResponse.status ?? "";
        if (jsonMap["Response"]["Status"].toLowerCase() == "success") {
          dynamic responseData;
          switch (endpoint) {
            case APIUrls.userLogin:
              if (outerResponse.data is List) {
                responseData = (outerResponse.data as List<dynamic>)
                    .map(
                      (e) => LoginCommonDataModel.fromJson(
                          e as Map<String, dynamic>),
                    )
                    .toList();
              } else if (outerResponse.data is Map) {
                responseData = LoginCommonDataModel.fromJson(
                    outerResponse.data as Map<String, dynamic>);
              }
              return Success(code: APICode.SUCCESS, response: responseData);
            case APIUrls.getCategories:
              if (outerResponse.data is List) {
                responseData = (outerResponse.data as List<dynamic>)
                    .map(
                      (e) => GetCategoriesDataModel.fromJson(
                          e as Map<String, dynamic>),
                    )
                    .toList();
              } else if (outerResponse.data is Map) {
                responseData = GetCategoriesDataModel.fromJson(
                    outerResponse.data as Map<String, dynamic>);
              }
              return Success(code: APICode.SUCCESS, response: responseData);

            default:
              return ApiResponseModel(
                  outerReponse: outerResponse,
                  responseData: Failure(
                      code: APICode.UNKNOWN_ERROR,
                      errorResponse: "Unknown error"));
          }
        } else if (jsonMap["Response"]["Status"].toLowerCase() == "failed") {
          var failedData;
          if (outerResponse.data is List) {
            failedData = (outerResponse.data as List<dynamic>)
                .map(
                  (faileddata) => FailedCommonDataModel.fromJson(
                      faileddata as Map<String, dynamic>),
                )
                .toList();
          } else if (outerResponse.data is Map) {
            failedData = [FailedCommonDataModel.fromJson(outerResponse.data)];
          }
          return Failed(
            code: APICode.Failed,
            response: failedData,
          );
        }
        return ApiResponseModel(
            outerReponse: outerResponse, responseData: outerResponse.data);
      } else {
        return Failure(code: APICode.Failed, errorResponse: "Invalid Response");
      }
    } on HttpException {
      return Failure(code: APICode.NO_INTERNET, errorResponse: "No Internet");
    } on FormatException {
      return Failure(
          code: APICode.INVALID_FORMAT, errorResponse: "Invalid Format");
    } catch (e) {
      return Failure(
          code: APICode.UNKNOWN_ERROR,
          errorResponse: "Unknown Error ${e.toString()}");
    }
  }

  String? extractStatusKey() {
    try {
      final outerResponse = statusKey;
      print("Check Key...${outerResponse}");
      return outerResponse;
    } catch (e) {
      return null;
    }
  }
}
