import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imgUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imgUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://flutter-shopkart.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (_) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }

  // Future<void> fetchFav(String authToken, String userId) async {
  //   final url =
  //       'https://flutter-shopkart.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
  //   try {
  //     final favResponse = await http.get(url);
  //     final favData = json.decode(favResponse.body) as Map<String, dynamic>;
  //     favData.forEach((key, value) {
  //       isFavorite = value['isFavorite'];
  //     });
  //     print(favData);
  //   } catch (error) {}
  // }
}
