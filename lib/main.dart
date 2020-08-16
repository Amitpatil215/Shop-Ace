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
        /*
        ChangeNotifierProvider.value(
          /// if our value is not depend on context then we use
          /// .value constructor
          /// avoid using .value if ur instantiating a new class like
          value: Products(),
          /*
         it is mainly used in list and grid view
         as it work fluently otherwise
         in case we delete a item in a list then flutter will not destroy
         widget instead of it will reassign the same basic structure
          */
        ),
        */
        // we wanna pass token from Auth() to ProductsOverview() so using
        // it dependes on the provider provided before this i.e auth()
        //<type of data u depend on , type of data u wanna provide>
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (context, authObject, previousState) => Products(
              //Passing token and list of items
              authObject.token,
              authObject.userId,
              //previousState.items, we cant pass like this cause
              //it can be null when initillay app started so
              // passing empty if nothing found elese list will be passed
              previousState == null ? [] : previousState.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (context, value, previous) => Orders(
            value.token,
            value.userId,
            previous == null ? [] : previous.orders,
          ),
        ),
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
              // if not authenticated i wanna try loging in automatically
              // so using future till that time i will show progress indicator
              : FutureBuilder(
                  // trying auto login
                  // if we logged in successfully then auth rebuilds due to notifyListeners()
                  // and our build reruns and we end up in product overview screen
                  future: authObject.tryAutoLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      // if we are unable to log in then show authentication screen
                      return AuthScreen();
                    }
                  },
                ),
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
