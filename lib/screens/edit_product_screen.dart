import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

//We want to manage user input so using statefulWidget
class EditProductScreen extends StatefulWidget {
  static const routName = "/edit-product-screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // * For fucusing the form field Price
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  // as in form we dont need text editing controller it manages in backend
  //but we wanna show user preview of image before form get submitted
  final _imageUrlController = TextEditingController();
  // * We need gloabal key for interacting saveForm() method and form() widget
  final _formKey = GlobalKey<FormState>(); //it holds state of a form
  // for validating image URL
  var isImageUrlCorect = false;
  // Empty product
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    // adding another lisener to focus node of an image
    _imageUrlFocusNode.addListener(
        //passing pointer of method
        //as we wanna execute this function once focus changes
        _updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    // We need to dispose all our
    // ! Focus Nodes else they will cause memory leak
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    //removing listener before image controller
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    super.dispose();
  }

  // when we change focus from image url input to other
  // our image also get updated
  // no need to press done(check in softKeyboard)
  void _updateImageUrl() {
    // negation of has focus is not in focus
    if (!_imageUrlFocusNode.hasFocus && isImageUrlCorect) {
      //only if it is out of focus and image url is correct
      setState(() {});
    }
  }

  void _saveForm() {
    // First validating user input
    if (_formKey.currentState.validate()) {
      // save the form
      _formKey.currentState.save();
      //adding  to our list of products
      Provider.of<Products>(context, listen: false).addProducts(_editedProduct);
      // Going back to the previous screen
      Navigator.of(context).pop();
    } else
      return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      // ! One can also use Column wrapped in SingleChildScrollView
      // cause once our field exceeds boundries flutter will lose user data
      // so dont use List View in that case. But we are using here
      // for Simplicity purpose
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
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
                onSaved: (value) {
                  _editedProduct = Product(
                    // only title value overwritten but other properties remains same
                    id: _editedProduct.id,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isNotEmpty)
                    return null;
                  else
                    return "Title can't be Empty";
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
                onFieldSubmitted: (enteredValue) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a price.";
                  }
                  // try parse returns value if value is double type
                  if (double.tryParse(value) == null) {
                    return "Enter Valid Number";
                  }
                  if (double.parse(value) <= 0) {
                    return "Please enter price greater than zero";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Description",
                ),
                // For longer inputs
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please Enter a description";
                  }
                  if (value.length < 10) {
                    return "Should be at least 10 character long";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text(
                            "Enter a URL",
                            textAlign: TextAlign.center,
                          )
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      //setting up editing controller
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide image URL";
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return "Enter Valid URL";
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpeg') &&
                            !value.endsWith('.jpg')) {
                          return "Not a Valid URL";
                        }
                        //true then only showing image preview
                        isImageUrlCorect = true;
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
