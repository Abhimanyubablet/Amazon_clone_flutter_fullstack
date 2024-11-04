import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart ' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/order.dart';
import '../../../providers/user_provider.dart';
import '../../auth/screens/auth_screen.dart';

class AccountServices{

  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res =
      await http.get(Uri.parse('$uri/api/orders/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void logOut(BuildContext context) async {
    try {
      // Access SharedPreferences instance
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      // Clear the stored authentication token
      await sharedPreferences.remove('x-auth-token');

      // Navigate to AuthScreen and remove all previous routes
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
            (route) => false,
      );
    } catch (e) {
      // Display error message in case of failure
      showSnackBar(context, 'Failed to log out. Please try again.');
    }
  }

}