import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';

// ! cartItem Clashing in both items
//  as we only need Cart for our provider
//  so using show key word we can acess to Cart only

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      "\$${cart.totalAmount}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // ! as Listview can be assigned in Column
          // using Expanded widget
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItemCount,
              itemBuilder: (ctx, index) {
                return CartItem(
                  // * WE TRYING TO ACESS MAP items
                  // * so first getting its value and then covertingit to list
                  // * there after acessing with each item indec
                  id: cart.items.values.toList()[index].id,
                  quantity: cart.items.values.toList()[index].quantity,
                  price: cart.items.values.toList()[index].price,
                  title: cart.items.values.toList()[index].title,
                  // * acessing key from list for dismissing item
                  dismissKey: cart.items.keys.toList()[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

//We wanna show progress indicator at the order botton
// so for making it state full extracting widget
class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading == true)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              //Sending info to Orders
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              //Clearing Cart items
              widget.cart.clearCart();
            },
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text("Order Now"),
    );
  }
}
