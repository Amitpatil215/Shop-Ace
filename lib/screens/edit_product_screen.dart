import 'package:flutter/material.dart';

//We want to manage user input so using statefulWidget
class EditProductScreen extends StatefulWidget {
  static const routName = "/edit-product-screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // * For fucusing the form field Price
  final _priceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      // ! One can also use Column wrapped in SingleChildScrollView
      // cause once our field exceeds boundries flutter will lose user data
      // so dont use List View in that case. But we are using here
      // for Simplicity purpose
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                // Creates a [FormField] that contains a [TextField]
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                // Shows next button in Soft Keyboard
                textInputAction: TextInputAction.next,
                //on pressing next button it will focus price form
                onFieldSubmitted: (valueEntered) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Price",
                ),
                // Shows next button in Soft Keyboard
                textInputAction: TextInputAction.next,
                //for number keyboard
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
