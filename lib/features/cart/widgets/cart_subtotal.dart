import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    num sum = 0;

    // Check if the cart is not null and iterate through its items
    if (user.cart != null) {
      for (var e in user.cart) {
        // Check if e, e['product'], and e['product']['price'] are not null
        if (e != null && e['quantity'] != null && e['product'] != null) {
          final quantity = e['quantity'];
          final price = e['product']['price'] ?? 0; // Default to 0 if price is null
          sum += quantity * price;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'Subtotal ',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            '\$$sum',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}