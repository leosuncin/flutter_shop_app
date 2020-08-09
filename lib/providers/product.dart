import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite = false;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite: false,
  });

  Product.empty()
      : this(
          id: null,
          title: '',
          description: '',
          price: null,
          imageUrl: '',
        );

  Product.from(Product another)
      : this(
          id: UniqueKey().toString(),
          title: another.title,
          description: another.description,
          price: another.price,
          imageUrl: another.imageUrl,
          isFavorite: another.isFavorite,
        );

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return '''Product{
      id: $id,
      title: $title,
      description: $description,
      price: $price,
      imageUrl:
      $imageUrl,
      isFavorite: $isFavorite
    }''';
  }
}
