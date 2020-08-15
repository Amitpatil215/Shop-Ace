import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth.dart';
import 'screens/edit_product_screen.dart';
import 'screens/user_product_screen.dart';
import 'screens/orders_screen.dart';
import 'providers/orders.dart';
import 'screens/cart_screen.dart';
import 'providers/cart.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'providers/products.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //for using multiple providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          // if our value is not depend on context then we use
          // .value constructor
          // avoid using .value if ur instantiating a new class like
          value: Products(),
          /*
         it is mainly used in list and grid view
         as it work fluently otherwise
         in case we delete a item in a list then flutter will not destroy
         widget instead of it will reassign the same basic structure
          */
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) {
            return Orders();
          },
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, authObject, child) => MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'GoogleSans',
          ),
          home: authObject.isAuthenticated
              ? ProductOverviewScreen()
              : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) {
              return ProductDetailScreen();
            },
            CartScreen.routName: (ctx) {
              return CartScreen();
            },
            OrdersScreen.routName: (ctx) {
              return OrdersScreen();
            },
            UserProductScreen.routName: (ctx) {
              return UserProductScreen();
            },
            EditProductScreen.routName: (ctx) {
              return EditProductScreen();
            }
          },
        ),
      ),
    );
  }
}
