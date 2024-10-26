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

class ProductDetailsServices {


  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Prepare the request data
      final url = "$uri/api/add-to-cart";
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token!,
      };
      final body = jsonEncode({
        "id": product.id,
      });

      // Print the request details for debugging
      print("Request URL: $url");
      print("Request Headers: $headers");
      print("Request Body: $body");

      // Make the POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Handle the response
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
         User user = userProvider.user.copyWith(
            cart: jsonDecode(response.body)["cart"]
          );

         userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      // Print error details and show a snackbar
      print("Error: $e");
      showSnackBar(context, e.toString());
    }
  }



  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Prepare the request data
      final url = "$uri/api/rate-product";
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token!,
      };
      final body = jsonEncode({
        "id": product.id,
        "rating": rating,
      });

      // Print the request details for debugging
      print("Request URL: $url");
      print("Request Headers: $headers");
      print("Request Body: $body");

      // Make the POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Handle the response
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          print("Product rated successfully.");
          showSnackBar(context, "Product rated successfully.");
        },
      );
    } catch (e) {
      // Print error details and show a snackbar
      print("Error: $e");
      showSnackBar(context, e.toString());
    }
  }
}
