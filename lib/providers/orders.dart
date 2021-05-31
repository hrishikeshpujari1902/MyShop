import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userid;
  Orders(this.userid, this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() {
    List<OrderItem> loadedOrders = [];
    final url = Uri.parse(
        'https://myshop-a6023-default-rtdb.firebaseio.com/orders/$userid.json?auth=$authToken');
    return http.get(url).then((response) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData != null) {
        extractedData.forEach((key, value) {
          loadedOrders.insert(
              0,
              OrderItem(
                id: key,
                amount: value['amount'],
                dateTime: DateTime.parse(value['dateTime']),
                products: (value['products'] as List<dynamic>)
                    .map((item) => CartItem(
                          id: item['id'],
                          title: item['title'],
                          price: item['price'],
                          quantity: item['quantity'],
                        ))
                    .toList(),
              ));
        });
      }
      _orders = loadedOrders;
      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) {
    final url = Uri.parse(
        'https://myshop-a6023-default-rtdb.firebaseio.com/orders/$userid.json?auth=$authToken');
    final timeStamp = DateTime.now();

    return http
        .post(url,
            body: json.encode({
              'amount': total,
              'dateTime': timeStamp.toIso8601String(),
              'products': cartProducts
                  .map((cp) => {
                        'id': cp.id,
                        'title': cp.title,
                        'quantity': cp.quantity,
                        'price': cp.price
                      })
                  .toList(),
            }))
        .then((response) {
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timeStamp,
            products: cartProducts),
      );
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }
}
