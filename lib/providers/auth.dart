import 'dart:convert';
import 'dart:math';
import 'api_key.dart' as ApiSecretKey;
import '../exception/http_error.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as httpUsing;

class Auth with ChangeNotifier {
  String _token; //token expires after one hour in firebase
  DateTime _expiryDate; //expiration time of that token
  String _userID;

  Future<void> _authenticate(
      {String email, String password, String urlSegment}) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${ApiSecretKey.api()}";
    try {
      final response = await httpUsing.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
    } catch (error) {
      print(json);
      throw error;
    }
  }

  Future<void> signUP({String email, String password}) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: "signUp",
    );
  }

  Future<void> logIn({String email, String password}) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: "signInWithPassword",
    );
  }
}
