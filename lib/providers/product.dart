import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isfavourite = false,
  });
  Future<void> favouriteToggle(String authToken, String userId) {
    final oldStatus = isfavourite;
    isfavourite = !isfavourite;
    notifyListeners();
    final url = Uri.parse(
        'https://myshop-a6023-default-rtdb.firebaseio.com/userfavourites/$userId/$id.json?auth=$authToken');
    return http
        .put(url,
            body: json.encode(
              isfavourite,
            ))
        .then((response) {
      if (response.statusCode >= 400) {
        isfavourite = oldStatus;
        notifyListeners();
      }
    }).catchError((_) {
      isfavourite = oldStatus;
      notifyListeners();
    });
  }
}
