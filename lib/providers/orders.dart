import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as httpUsing;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  // Which products are in our cart
  final List<CartItem> products;
  // Time when order is placed
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  // getter for returning order items List
  List<OrderItem> get orders {
    return [..._orders];
    // acessing copy of _orders
    // due to this outside of class we cant acess the orders
  }

  //Adding orders from cart
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-ace.firebaseio.com/orders.json';
    // storing time cause http may take time some time to load if we initiated it in map directly
    // so for no delay in actul time
    final timeStamp = DateTime.now();
    final response = await httpUsing.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamp
              .toIso8601String(), // easy to convertable to dart when decoding
          'products': cartProducts.map((everyCartProduct) {
            //maping cartproducts to list products
            return {
              'id': everyCartProduct.id,
              'title': everyCartProduct.title,
              'quantity': everyCartProduct.quantity,
              'price': everyCartProduct.price,
            };
          }).toList()
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
        //using auto generated id for the order from firebase
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
