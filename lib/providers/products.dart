import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 499,
    //   imgUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 599,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/f/fb/Trousers.jpg',
    // ),
  ];
  final String authToken;
  final String userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prod) => prod.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchNSaveProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://flutter-shopkart.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);

      final List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      if (extractedData.isEmpty) {
        _items = [];
      }
      final url1 =
          'https://flutter-shopkart.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favResponse = await http.get(url1);
      final favData = json.decode(favResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.insert(
          0,
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imgUrl: prodData['imgUrl'],
            isFavorite: favData == null ? false : favData[prodId] ?? false,
          ),
        );
        _items = loadedProducts;
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-shopkart.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imgUrl': product.imgUrl,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imgUrl: product.imgUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }

    // }).catchError((error) {
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-shopkart.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'title': updatedProduct.title,
          'description': updatedProduct.description,
          'price': updatedProduct.price,
          'imgUrl': updatedProduct.imgUrl,
        }),
      );
      _items[prodIndex] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shopkart.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
