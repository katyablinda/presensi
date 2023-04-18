import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/my_response.dart';
import '../../model/user_model.dart';
import 'login_repository.dart';

class LoginController {
  final LoginRepository _repository = LoginRepository();

  bool isLoading = false;

  Future<MyResponse> login(String username, String password) async {
    http.Response result = await _repository.login(username, password);

    if (result.statusCode == 200) {
      Map<String, dynamic> myBody = jsonDecode(result.body);
      //convert hasil json

      MyResponse<User> myResponse = MyResponse.fromJson(myBody, User.fromJson);

      if (myResponse.status == 200) {
        final prefs = await SharedPreferences.getInstance();
        //SET token dan set absen ID
        await prefs.setString("token", myResponse.data?.token ?? "TIDAK ADA");
        await prefs.setString(
            'absensiID', myResponse.data?.absensiID ?? "null");
      }

      return myResponse;
    } else {
      return MyResponse(status: 400, message: "Terjadi Kesalahan");
    }
  }
}
