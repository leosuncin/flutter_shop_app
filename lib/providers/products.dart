import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class Products with ChangeNotifier, DiagnosticableTreeMixin {
  List<Product> _items = [];

  List<Product> get items => [..._items];

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('items', items));
  }
}
