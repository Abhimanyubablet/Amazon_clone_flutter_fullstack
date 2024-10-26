
 import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
   User _user= User(
      id: '',
      name: '',
      email: '',
      password: '',
      address: '',
      type: '',
      token: ''
  );

   User get user => _user;

   void setUser(String user) {
     Map<String, dynamic> userMap = jsonDecode(user);
     _user = User.fromJson(userMap);
     notifyListeners();
   }

}