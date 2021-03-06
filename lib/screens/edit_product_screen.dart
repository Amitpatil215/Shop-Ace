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
  var _isProductInitialized = false;
  //when we save wanna show loading inficator
  var _isLoading = false;
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  // For a new product
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    // adding another lisener to focus node of an image
    _imageUrlFocusNode.addListener(
        //passing pointer of method
        //as we wanna execute this function once focus changes
        _updateImageUrl);
    super.initState();
  }

  //it runs befor build
  @override
  void didChangeDependencies() {
    if (_isProductInitialized == false) {
      //as didChangeDependencies runs multiple time we dont want to reinitialize our product
      //so setting it to true
      _isProductInitialized = true;
      //getting id of a perticular product for editing
      final editId = ModalRoute.of(context).settings.arguments as String;

      // we dont have id means we want to create new product
      if (editId == null) {
      }
      // if we got id that means we wanna edit existing product
      else {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(editId);

        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // ! We cant use initial value and editing controller both like this
          // !'imageUrl': _editedProduct.imageUrl,
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // ? Should i dispose it or not cause some same
    // ? it will get disposed once widget closes
    // We need to dispose all our
    // ! Focus Nodes else they will cause memory leak
    // _priceFocusNode.dispose();
    // _descriptionFocusNode.dispose();
    // _imageUrlFocusNode.dispose();
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

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });

    // First validating user input
    if (_formKey.currentState.validate()) {
      // save the form
      _formKey.currentState.save();

      //  means we editing existing product
      if (_editedProduct.id != null) {
        //updating  to our list of products
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
        setState(() {
          _isLoading = false;
        });
        // Going back to the previous screen
        Navigator.of(context).pop();
      }
      //we need to save new product
      else {
        try {
          //adding  to our list of products
          await Provider.of<Products>(context, listen: false)
              .addProducts(_editedProduct);
        } catch (error) {
          await showDialog(
              //we returning future of showDialog with value of Null
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text("Error Occured!"),
                  content: Text("Something Went Wrong"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Okay"))
                  ],
                );
              });
          //finally includes code which must be exicuted after try and catch
        } finally {
          // Going back to the previous screen
          // data stored in database as well as in provider
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }
      }
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                      //setting initial value
                      initialValue: _initValues['title'],
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
                          isFavorite: _editedProduct.isFavorite,
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
                      //setting initial value
                      initialValue: _initValues['price'],
                      // Shows next button in Soft Keyboard
                      textInputAction: TextInputAction.next,
                      //for number keyboard
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (enteredValue) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
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
                      //setting initial value
                      initialValue: _initValues['description'],
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
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
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            // ! Cant use initialValue & Controller simultaneously
                            //setting initial value
                            //initialValue: _initValues['imageUrl'],
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
                                isFavorite: _editedProduct.isFavorite,
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
