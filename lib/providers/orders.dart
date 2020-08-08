import 'package:flutter/foundation.dart';
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
  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
