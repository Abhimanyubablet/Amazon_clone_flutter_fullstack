

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/product_dart.dart';
import '../../../providers/user_provider.dart';

class SearchServices {
  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    // Construct the full URL
    final String url = "$uri/api/products/search/$searchQuery";
    print("Requesting URL: $url");

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token!,
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final List<dynamic> responseBody = jsonDecode(response.body);
          for (var product in responseBody) {
            productList.add(Product.fromJson(jsonEncode(product)));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      print("Error: $e");
    }
    return productList;
  }
}
