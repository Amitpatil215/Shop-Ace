import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/Product-Detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;

    // Getting details of particular id
    //accessing provider of products having getter items by filtering out with matching id
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
      //we don't wanna rebuild this screen
      //in case if we add a new product
      //so we set to false the listen argument
    ).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
