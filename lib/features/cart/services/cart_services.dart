import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/product_dart.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          // Parse the updated cart from the response.
          final updatedCart = jsonDecode(response.body)["user"]["cart"];

          // Update the user with the new cart state.
          User updatedUser = userProvider.user.copyWith(cart: updatedCart);
          userProvider.setUserFromModel(updatedUser);

          // Optional: Show feedback to the user.
          showSnackBar(context, "Product removed from cart!");

        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}