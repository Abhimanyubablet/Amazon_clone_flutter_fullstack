import 'dart:convert';

import 'package:amazon_flutter_tutorial/models/product_dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';
import 'package:http/http.dart' as http;

class HomeServices {

  Future<List<Product>> fetchCategoryProducts({required BuildContext context, required String category}) async{
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response response = await http.get(Uri.parse("$uri/api/products?category=$category"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token!,
      });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            for (int i = 0; i <= jsonDecode(response.body).length - 1; i++) {
              productList.add(Product.fromJson(jsonEncode(jsonDecode(response.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      print(e);
    }
    return productList;
  }

  Future<Product> fetchDealOfDay({required BuildContext context}) async{
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
        name: "",
        description: "",
        quantity: 0,
        images: [],
        category: "",
        price: 0
    );
    try {
      http.Response response =
      await http.get(Uri.parse("$uri/api/deal-of-day"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token!,
      });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            product = Product.fromJson(response.body);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      print(e);
    }
    return product;
  }

}