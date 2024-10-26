import 'dart:convert';
import 'dart:io';

import 'package:amazon_flutter_tutorial/constants/error_handling.dart';
import 'package:amazon_flutter_tutorial/constants/global_variables.dart';
import 'package:amazon_flutter_tutorial/constants/utils.dart';
import 'package:amazon_flutter_tutorial/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../models/product_dart.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('dqm4jvjn2', 'esghnwql');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        if (kDebugMode) {
          print(res.secureUrl);
        }
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/admin/add-product"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token!,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Product Added Successfully ! ");
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString());

      print(e);
    }
  }

  // get all the products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response response =
          await http.get(Uri.parse("$uri/api/admin/get-products"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token!,
      });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            for (int i = 0; i <= jsonDecode(response.body).length - 1; i++) {
              productList.add(
                  Product.fromJson(jsonEncode(jsonDecode(response.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      print(e);
    }
    return productList;
  }

  void deleteProduct(
      {required BuildContext context,
      required Product product,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/admin/delete-product"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token!,
        },
        body: jsonEncode({
          "id" : product.id,
        },)
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
           onSuccess();
          });
    } catch (e) {
      showSnackBar(context, e.toString());

      print(e);
    }
  }
}
