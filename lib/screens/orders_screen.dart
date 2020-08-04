import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (_, index) => OrderItem(
          order: orders.elementAt(index),
        ),
      ),
    );
  }
}
