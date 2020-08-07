import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  FlatButton(
                    onPressed: () {},
                    child: Text("Order Now"),
                  )
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
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
