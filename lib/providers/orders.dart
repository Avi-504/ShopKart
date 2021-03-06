import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime time;

  OrderItem({
    @required this.amount,
    @required this.id,
    @required this.products,
    @required this.time,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  Orders(this.authToken, this._orders, this.userId);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchNSaveOrders() async {
    final url =
        'https://flutter-shopkart.firebaseio.com/orders.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          amount: orderData['amount'],
          id: orderId,
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
          time: DateTime.parse(
            orderData['time'],
          ),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-shopkart.firebaseio.com/orders.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'creatorId': userId,
          'amount': total,
          'time': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        id: json.decode(response.body)['name'],
        products: cartProducts,
        time: timeStamp,
      ),
    );
    notifyListeners();
  }
}
