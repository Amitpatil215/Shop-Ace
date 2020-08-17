import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //This is old way we using earlier
    //we not listening here cause we want title only once
    final eachProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authToken = Provider.of<Auth>(context, listen: false).token;
    final authUserId = Provider.of<Auth>(context, listen: false).userId;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: eachProduct.id,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
          child: Hero(
            tag: eachProduct.id,
            child: FadeInImage(
              placeholder: AssetImage(
                'assets/images/product-placeholder.png',
              ),
              image: NetworkImage(eachProduct.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              eachProduct.title,
              textAlign: TextAlign.center,
            ),
            //alternative way of using listener as Consumer
            //it will only run on its returned and child widgets
            //rather than running over complete build
            leading: Consumer<Product>(
              builder: (ctx, eachProduct, child) => IconButton(
                //here we getting a child
                //it used in case if you don't want to rebuild that widget
                icon: Icon(
                  eachProduct.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  eachProduct.toggleFavoriteStatus(authToken, authUserId);
                },
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItem(
                  eachProduct.id,
                  eachProduct.price,
                  eachProduct.title,
                );
                //If ther alredy Snack Bar exist on the screen
                //then first remove the same
                Scaffold.of(context).hideCurrentSnackBar();
                //For Showing Snackbar
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    elevation: 5,
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    content: Text("Added Item to the cart"),
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.white,
                      onPressed: () {
                        cart.removeSingleItem(eachProduct.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
