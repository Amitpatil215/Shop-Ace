import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  // Getting copy of above items Map
  Map<String, CartItem> get items {
    return {..._items};
  }

  // Adding a item
  // * not getting item 'cause we assuming it 1
  void addItem(String productId, double price, String title) {
    // if we have item already then only increase its quantity count
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingValue) => CartItem(
                id: existingValue.id,
                title: existingValue.title,
                quantity: existingValue.quantity + 1,
                price: existingValue.price,
              ));
    } else {
      _items.putIfAbsent(productId, () {
        return CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        );
      });
    }
    notifyListeners();
  }

  //for removing item from cart screen
  void removeItem(String dismissKey) {
    _items.remove(dismissKey);
    notifyListeners();
  }

  // By placing order we have to clear cart
  void clearCart() {
    _items = {};
    notifyListeners();
  }

  //getter for how many items added in cart
  int get cartItemCount {
    return _items.length;
  }

  //For removing Single Item From Dart
  void removeSingleItem(String productId) {
    //weather it is a part of cart
    if (!_items.containsKey(productId)) {
      return;
    }
    //If it is greter than 1 then we need to remove it by 1
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingValue) => CartItem(
                id: existingValue.id,
                title: existingValue.title,
                quantity: existingValue.quantity - 1,
                price: existingValue.price,
              ));
    }
    //If it equal to 1 then reomve entire item
    if (_items[productId].quantity == 1) {
      _items.remove(productId);
      notifyListeners();
    }
  }

  //
  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total = total + value.price * value.quantity;
    });
    return total;
  }
}
