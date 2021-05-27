import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  //var _showFavouritesOnly = false;
  //void showFavouritesOnly() {
  //  _showFavouritesOnly = true;
  //  notifyListeners();
  //}

  //void showAll() {
  //  _showFavouritesOnly = false;
  //  notifyListeners();
  //}

  List<Product> get items {
    //if (_showFavouritesOnly) {
    // return _items.where((element) => element.isfavourite).toList();
    //}
    // ignore: sdk_version_ui_as_code
    return [..._items];
  }

  List<Product> get foavouriteList {
    return _items.where((element) => element.isfavourite).toList();
  }

  Product findById(String sid) {
    return _items.firstWhere((element) => element.id == sid);
  }

  // bool stringToBool(String string) {
  //   bool isfav;
  //   if (string.compareTo('true') == 0) {
  //     isfav = true;
  //   }
  //   if (string.compareTo('false') == 0) {
  //     isfav = false;
  //   }
  //   return isfav;
  // }

  Future<void> fetchProducts() {
    final url = Uri.parse(
        'https://myshop-a6023-default-rtdb.firebaseio.com/products.json');
    return http.get(url).then((response) {
      print(response.body);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData != null) {
        extractedData.forEach((key, value) {
          loadedProducts.insert(
            0,
            Product(
                id: key,
                title: value['title'],
                description: value['description'],
                price: value['price'],
                isfavourite: value['isfavourite'],
                imageUrl: value['imageUrl']),
          );
        });
      }
      _items = loadedProducts;
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> addNewProduct(Product product) {
    final url = Uri.parse(
        'https://myshop-a6023-default-rtdb.firebaseio.com/products.json');
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isfavourite': product.isfavourite,
      }),
    )
        .then((response) {
      print(json.decode(response.body));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }
  // using async
  //Future<void> addNewProduct(Product product) async {
  // final url = Uri.parse(
  //      'https://myshop-a6023-default-rtdb.firebaseio.com/products.json');
  //try{
  //  final reponse=await http
  //     .post(
  //    url,
  //    body: json.encode({
  //      'title': product.title,
  //      'description': product.description,
  //     'price': product.price,
  //      'imageUrl': product.imageUrl,
  //     'isfavourite': product.isfavourite,
  //   }),
  // );
  //  print(json.decode(response.body));
  //   final newProduct = Product(
  //     id: json.decode(response.body)['name'],
  //     title: product.title,
  //     description: product.description,
  //     price: product.price,
  //     imageUrl: product.imageUrl,
  //   );
  //   _items.insert(0, newProduct);
  //   notifyListeners();
  // );
  //  }catch(error){
  //      throw error;
  //  }
  //
  //
  //
  //}

  Future<void> editProduct(String id, Product product) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url = Uri.parse(
          'https://myshop-a6023-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) {
    final url = Uri.parse(
        'https://myshop-a6023-default-rtdb.firebaseio.com/products/$id.json');
    var existingProductIndex = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    return http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Could not deletye the product');
      }
      existingProduct = null;
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
  }
}
