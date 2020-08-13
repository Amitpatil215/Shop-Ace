import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function deleteProduct;

  const UserProductItem(
      {this.deleteProduct, this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    //scaffold context in variable to use in future methods where we cant use context
    final scaffoldVariable = Scaffold.of(context);
    final themeContextVariable = Theme.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        //Not using row directly as widget to trailing  cause
        // ! trailing can not restrict row to take as much size it want
        // so resolving it by adding Container
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routName,
                  arguments: id,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await deleteProduct(id);
                  scaffoldVariable.showSnackBar(
                    SnackBar(
                      content: Text("Succesfully Deleted!"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (error) {
                  // ! we can not use context in future i.e. in await
                  //Scaffold.of(context).showSnackBar()
                  // by using variable in build method we resolved issue
                  scaffoldVariable.showSnackBar(
                    SnackBar(
                      content: Text("Deleting Failed !"),
                      backgroundColor: themeContextVariable.errorColor,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
