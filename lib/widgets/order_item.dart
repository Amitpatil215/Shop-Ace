import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// * We have widget class with Name of OrderItem in
// providers/orders.dart & widget/order_item.dart so using ord
import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  //acessing OrderItem from 'ord' dile
  final ord.OrderItem order;

  const OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${order.amount}"),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)),
            trailing:
                IconButton(icon: Icon(Icons.expand_more), onPressed: () {}),
          )
        ],
      ),
    );
  }
}
