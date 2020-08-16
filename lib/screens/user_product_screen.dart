import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routName = '/user-product';

  Future<void> _refreshProducts(BuildContext ctx) async {
    //async will return future automatically
    await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts(true);
    //passing true in fetch and set products
    // wanna show only products creatoted by the user
  }

  @override
  Widget build(BuildContext context) {
    // dont wanna fetch data from local due to filtering products in manage products
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      // Reloading this screen also not getting from loacal state
      // otherwise we will get all products in by creator
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return _refreshProducts(context);
                    },
                    child: Consumer<Products>(
                      builder: (context, productsData, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (ctx, index) {
                            return Column(children: [
                              UserProductItem(
                                id: productsData.items[index].id,
                                title: productsData.items[index].title,
                                imageUrl: productsData.items[index].imageUrl,
                                deleteProduct: productsData.deleteProduct,
                              ),
                              Divider(),
                            ]);
                          },
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
