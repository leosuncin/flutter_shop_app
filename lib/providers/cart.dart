import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    this.quantity = 1,
  });

  CartItem copyWith({
    String title,
    int quantity,
    double price,
  }) {
    return CartItem(
      id: id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}

class Cart with ChangeNotifier, DiagnosticableTreeMixin {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double get total => _items.values.fold(
        0,
        (previousValue, item) => item.price * item.quantity + previousValue,
      );

  int get itemCount => _items.length;

  void addItem({
    String productId,
    double price,
    String title,
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (old) => old.copyWith(quantity: old.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: UniqueKey().toString(),
          title: title,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  CartItem itemAt(int index) {
    return _items.values.toList().elementAt(index);
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty<Map<String, CartItem>>('items', items));
    properties.add(DoubleProperty('total', total, defaultValue: 0));
    properties.add(IntProperty('itemCount', itemCount, defaultValue: 0));
  }
}
