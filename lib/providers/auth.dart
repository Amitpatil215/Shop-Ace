import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as httpUsing;

class Auth with ChangeNotifier {
  String _token; //token expires after one hour in firebase
  DateTime _expiryDate; //expiration time of that token
  String _userID;

  Future<void> signUP({String email, String password}) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAQkByUtD5ykXQnswrV2QQvEkwHcNCpWY0";
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
    print(json.decode(response.body));
  }
}
