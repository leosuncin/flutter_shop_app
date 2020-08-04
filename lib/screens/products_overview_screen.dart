import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/product_item.dart';
import '../providers/products.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loadedProducts = context.watch<Products>().items;

    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: loadedProducts.elementAt(index),
          child: ProductItem(),
        ),
      ),
    );
  }
}
