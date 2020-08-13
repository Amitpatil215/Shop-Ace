import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/products.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoritesOnly = false;
  var _isInit = false; //Checking did we initiallized products erlier
  var _isLoading = false; // for showing loading spinner

  @override
  void didChangeDependencies() {
    // ! context in initState wont work so using didChangeDependencies
    // it will work if we set listen to false
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });
      _isInit = true;
      Provider.of<Products>(context).fetchAndSetProducts().then(
            (_) => setState(() {
              _isLoading = false;
            }),
          );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cartData, chiiild) => Badge(
              value: cartData.cartItemCount.toString(),
              child: chiiild,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavoritesOnly = true;
                } else
                  _showFavoritesOnly = false;
              });
            },
            elevation: 5,
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text("Only Favorites"),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text("Show All"),
                  value: FilterOptions.All,
                ),
              ];
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : ProductsGrid(_showFavoritesOnly),
    );
  }
}
