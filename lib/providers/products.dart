import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'product.dart';
import 'dart:convert'; //for converting our product to JSON format
import 'package:http/http.dart' as httpUsing;

//mix in use with keyword
// We getting features all the features of ChangeNotifier
class Products with ChangeNotifier {
  //list of product in Products class
  //as _items is private it never be accessed by outside of this class

  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ), */
  ];

  //we not going to return above list cause it will give pointer
  //as it will give direct access to the actual list
  //instead of that we create getter

  //getter returning the list of products
  List<Product> get items {
    return [..._items];
    //[_items] : it returns copy of _items as we don't wanna bother actual list
    // ...spread operator is used for accessing the pointer _items and then
    // returning it as a copy made by []
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

//Getting products from firebase
  Future<void> fetchAndSetProducts() async {
    const url = 'https://shop-ace.firebaseio.com/products.json';
    try {
      // sending http request to the firebase
      final response = await httpUsing.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      //For every unique key where key is product id and value is the map of products data
      extractedData.forEach((key, value) {
        loadedProducts.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite'],
          ),
        );
      });
      // initillay we have dummy list of products but not we fetching it from firebase
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      //we can handle this error in widget so throwing it
      throw (error);
    }
  }

  //This class used by provider package
  //so it will create communication channel between data and widget
  //who want to access data
  // function return future
  Future<void> addProducts(Product newProduct) async {
    // we creating products type in json format so /products.json
    const url = 'https://shop-ace.firebaseio.com/products.json';
    try {
      //we trying in try{} to run code if not run then it throws error in catch{}
      // sending a post request for sending data
      //now we dont need to return cause async returns future automatically
      // await says wait till this code runs
      final responseValue = await httpUsing.post(
        url,
        body: json.encode(
          //as encode can covert map to json passing a map
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavorite': newProduct.isFavorite,
          },
        ),
      );

      // we have a special key returned by the firebase in name:
      // using it in place of our id for creating it locally
      final createProduct = Product(
          id: json.decode(responseValue.body)['name'],
          title: newProduct.title,
          description: newProduct.description,
          imageUrl: newProduct.imageUrl,
          price: newProduct.price,
          isFavorite: newProduct.isFavorite);

      //adding product at the end of list
      _items.add(createProduct);

      // * for begining of the list
      //_items.insert(0, createProduct);

      // you can print response which shows name: with unique id
      // print(json.decode(responseValue.body));
      notifyListeners();
    } catch (errorMessege) {
      //In case we got an error  we should handle it
      //else our app may crash
      //we wanna handle this error in the edit product screen
      throw errorMessege;
    }
  }

  void updateProduct(String id, Product updatedProduct) {
    //We getting index of product which we wanna edit
    final productIndex = _items.indexWhere((element) => element.id == id);
    //checking did we really hot the index
    if (productIndex >= 0) {
      //replacing existing product with new product
      _items[productIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
