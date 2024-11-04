
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/widgets/bottom_bar.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../providers/user_provider.dart';
import '../../admin/screens/admin_screen.dart';

class AuthService {
  // Sign up method to register a user
  void signUpUser({required String email, required String password, required String name, required BuildContext context,}) async {
    try {
      // User user = User(
      //   id: '',
      //   name: name,
      //   password: password,
      //   address: '',
      //   type: '',
      //   token: '',
      //   email: email,
      // );
      Map<String, String> requestBody = {
        'name': name,
        'email': email,
        'password': password,
      };

      // Send the POST request
      final response = await http.post(Uri.parse('$uri/api/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      print('Error during sign up: $e');
    }
  }

  // Sign In method to register a user
  void signInUser({required String email, required String password, required BuildContext context,}) async {
    try {
      Map<String, String> requestBody = {
        'email': email,
        'password': password,
      };

      // Send the POST request
      final response = await http.post(Uri.parse('$uri/api/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async{
           SharedPreferences prefs = await SharedPreferences.getInstance();
           Provider.of<UserProvider>(context, listen: false).setUser(response.body);
           await prefs.setString("x-auth-token", jsonDecode(response.body)["token"]);

           if(jsonDecode(response.body)["type"] == "user"){
             Navigator.pushNamed(context, BottomBar.routeName);
           }
           else{
             Navigator.pushNamed(context, AdminScreen.routeName);
           }

        },
      );
    } catch (e) {
      print('Error during sign up: $e');
    }
  }


  // get user data security
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");
      if(token == null){
         prefs.setString("x-auth-token", "");
      }

      var tokenRes = await http.post(
        Uri.parse("$uri/api/tokenIsValid"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token' : token! ,
        },
      );

      print('Token Validation Response: ${tokenRes.body}');

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/api'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        print('User Data Response: ${userRes.body}');
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }

    } catch (e) {
      print('Error during sign up: $e');
      // showSnackBar(context, e.toString());
    }
  }
}
