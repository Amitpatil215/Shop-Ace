import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //This is old way we using earlier
    //we not listening here cause we want title only once
    final eachProduct = Provider.of<Product>(context, listen: false);

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
          child: Image.network(
            eachProduct.imageUrl,
            fit: BoxFit.cover,
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
                  eachProduct.toggleFavoriteStatus();
                },
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
