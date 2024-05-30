import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/features/login/model/login_data_mode.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/repo/api_urls.dart';
import '../../../constant/constant.dart';
import '../../../repo/api_repository.dart';
import '../../../repo/response_handler.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  bool showPass = false;
  bool validateCredentials(String username, String password) {
    if (username.isEmpty) {
      Constant.showLongToast("Please enter user name");
      return false;
    } else if (password.isEmpty) {
      Constant.showLongToast("Please enter password");
      return false;
    }
    return true;
  }

  LoginBloc() : super(LoginInitial()) {
    on<LoginOnTapEvent>(loginOnTapEvent);
    on<LoginShowPasswordEvent>(loginShowPasswordEvent);
  }

  FutureOr<void> loginOnTapEvent(
      LoginOnTapEvent event, Emitter<LoginState> emit) async {
    List<LoginCommonDataModel> empDataList = <LoginCommonDataModel>[];
    List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];

    try {
      Map<String, String> empParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "username": event.username,
        "password": event.password,
      };

      var response = await APIRepository()
          .getCommonMethodAPI(empParameter, APIUrls.userLogin);
      if (response is Success) {
        empDataList.clear();
        if (response.response is List<LoginCommonDataModel>) {
          empDataList = response.response as List<LoginCommonDataModel>;
        } else if (response.response is LoginCommonDataModel) {
          empDataList.add(response.response as LoginCommonDataModel);
        }
        print(empDataList.first.name);
        var responseKey = APIRepository().extractStatusKey();
        emit(LoginSuccessState(data: empDataList));
        if (responseKey?.toLowerCase() == "success") {
          await employeeSharedPrefData(empDataList, event);
        }
        print("Logged in");
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(LoginErrorState(message: failedList.first.message.toString()));
      } else if (response is Failure) {
        emit(LoginErrorState(message: response.errorResponse.toString()));
      } else {
        emit(LoginErrorState(message: "An error occurred"));
      }
    } catch (e) {
      emit(LoginErrorState(message: "Error occurred!!! ${e.toString()}"));
    }
  }

  Future<void> employeeSharedPrefData(
      List<LoginCommonDataModel> userDataList, LoginOnTapEvent event) async {
    PreferenceUtils.setString(UserData.username.key, event.username);
    PreferenceUtils.setString(UserData.password.key, event.password);
    PreferenceUtils.setString(UserData.id.key, userDataList.first.id ?? "");
    PreferenceUtils.setString(UserData.name.key, userDataList.first.name ?? "");
    PreferenceUtils.setString(UserData.isLogin.key, true.toString());
  }

  FutureOr<void> loginShowPasswordEvent(
      LoginShowPasswordEvent event, Emitter<LoginState> emit) {
    print("BLOC METHOD ${event.showPass}");
    showPass = event.showPass;
    emit(LoginShowPasswordState(showPass: showPass));
  }
}
