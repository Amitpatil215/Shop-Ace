import 'dart:convert';
import 'dart:async'; // for timer purpose auto log out
import 'api_key.dart' as ApiSecretKey;
import '../exception/http_error.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as httpUsing;

class Auth with ChangeNotifier {
  String _token; //token expires after one hour in firebase
  DateTime _expiryDate; //expiration time of that token
  String _userID;
  Timer _authTimer;

  bool get isAuthenticated {
    return token != null;
    //we getting token from getter which locally validate
    // that means we are authenticated
  }

  String get userId {
    return _userID;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      // if expiry date is further that current time our token is valid
      return _token;
    } else {
      return null;
    }
  }

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
      // if we dont have error then setting up to the properties
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      //adding seconds to current time will give us the time when token expires

      // setting auto log out feature once user log in
      _autoLogout();
      notifyListeners();
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

  void logOut() {
    _token = null;
    _expiryDate = null;
    _token = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    // when we notifi this to provider
    // in main home : where we check is authenticated or not then it will
    //return a false so we render AuthScreeen() in front
  }

  // * automatically log out when token expires
  void _autoLogout() {
    if (_authTimer != null) {
      // if we have existing timer then cancel it first
      _authTimer.cancel();
    }

    // difference between expiry time and current time
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    // first argument when it expires
    // second argument what should happen after that
    // timer exicutes method once its time expires
    _authTimer = Timer(
      Duration(seconds: timeToExpiry),
      logOut,
    );
  }
}
