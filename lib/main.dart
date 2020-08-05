import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      // if our value is not depend on context then we use
      // .value constructor
      // avoid using .value if ur instantiating a new class like
      value: Products(),
      //but we using here as it will not affect this application
      /*
     it is mainly used in list and grid view
     as it work fluently otherwise
     in case we delete a item in a list then flutter will not destroy
     widget instead of it will reassign the same basic structure
      */
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'GoogleSans',
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) {
            return ProductDetailScreen();
          }
        },
      ),
    );
  }
}
