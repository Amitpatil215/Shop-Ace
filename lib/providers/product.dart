import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as httpUsing;
import '../exception/http_error.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    //setting old Status of is favourite ,using Optimistic update
    var oldFavStatus = isFavorite;
    //  if value is true it it make false nd voice versa
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shop-ace.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      //as we only sending one value we dont need to send a map
      // so if there already product exist then it will replace else create
      final response = await httpUsing.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        throw HttpException();
      }
    } catch (error) {
      isFavorite = oldFavStatus;
      notifyListeners();
    } finally {
      oldFavStatus = null;
    }
  }
}
