import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routName = '/orders';

  // var _isLoading = false;

/*
  @override
  void initState() {
    /// as we cant use future in init state
    /// using special function future delayed with value of .zero duration
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }
*/
  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders!"),
      ),
      drawer: AppDrawer(),
      // * Using FutureBuilder instead of seeting state of _isLoading
      // so just for fetching data we dont need to make it statefull
      // it also avoid rebuilding of build method just cause of _isLoading
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, currentDataSnapshot) {
          if (currentDataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentDataSnapshot.error != null) {
            // do error handling here
            return Center(
              child: Text("error Ocuured"),
            );
          }
          // if (currentDataSnapshot.connectionState == ConnectionState.done)
          else {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, index) {
                  return OrderItem(orderData.orders[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
