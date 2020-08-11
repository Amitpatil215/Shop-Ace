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
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  // as in form we dont need text editing controller it manages in backend
  //but we wanna show user preview of image before form get submitted
  final _imageUrlController = TextEditingController();

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
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

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
                onFieldSubmitted: (enteredValue) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
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
                      //setting up editing controller
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
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
