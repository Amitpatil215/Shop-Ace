import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String dismissKey;

  const CartItem({
    this.id,
    this.price,
    this.quantity,
    this.title,
    this.dismissKey,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      // * Swiping from right to left allowed only
      direction: DismissDirection.endToStart,
      onDismissed: (swipeDirection) {
        Provider.of<Cart>(context, listen: false).removeItem(dismissKey);
      },
      background: Container(
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text("\$$price"),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total :\$${price * quantity}"),
            trailing: Text("$quantity  X"),
          ),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Are you Sure.."),
              content: Text('Do you want to remove the item from the cart?'),
              elevation: 20,
              actions: [
                FlatButton(
                  onPressed: () {
                    //after pressing NO Dialog closes
                    // and false value is returned to the future
                    // ofConfirm Dismiss
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text("No"),
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text("Yes"))
              ],
            );
          },
        );
      },
    );
  }
}
