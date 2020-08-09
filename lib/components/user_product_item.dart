import 'package:flutter/material.dart';

import '../providers/product.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: theme.primaryColor,
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName,
                    arguments: product);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: theme.errorColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
