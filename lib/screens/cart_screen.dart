import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cart_item.dart';
import '../providers/cart.dart' hide CartItem;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final cart = context.watch<Cart>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    label: Text(
                      '\$${cart.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: theme.primaryTextTheme.headline6.color,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    textColor: theme.primaryColor,
                    child: Text('Order now'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (_, index) {
                final item = cart.itemAt(index);

                return CartItem(
                  id: item.id,
                  price: item.price,
                  quantity: item.quantity,
                  title: item.title,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
