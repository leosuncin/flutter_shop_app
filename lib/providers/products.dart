import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'product.dart';

class Products with ChangeNotifier, DiagnosticableTreeMixin {
  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      '$apiUrl/products',
      body: json.encode(product.toJson()),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final body = json.decode(response.body);
    _items.add(Product.fromJson(body));
    notifyListeners();
  }

  Product getById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void updateProduct(Product product) {
    final index = _items.indexOf(product);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get('$apiUrl/products?limit=30');
      final data = json.decode(response.body) as List<dynamic>;
      _items = data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print(error);
      _items = [];
    } finally {
      notifyListeners();
    }
  }

  void removeProduct(String productId) {
    _items.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('items', items));
  }
}
