import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';
import 'package:mycart/model/login_request.dart';

import 'package:mycart/model/products_model.dart';
import 'package:mycart/model/sqlite/sqlite_model.dart';
import 'package:mycart/resources/utilities/cart_secure_store.dart';

import '../model/user_model.dart';

class UserRepository {
  Future<User> addUser(User user) async {
    final response = await SqlUser(
            userName: user.userName,
            passWord: user.passWord,
            profile: user.profile,
            dateOfBirth: user.dateOfBirth)
        .upsert();

    var userResponse = await SqlUser().select().toList();
    print(userResponse.last.toMap());
    return User.fromJson(userResponse.last.toMap());
  }

  Future<User?> loginUser(LoginRequest user) async {
    final response =
        await SqlUser().select().userName.equals(user.userName).toSingle();
    if (response == null) {
      throw Exception("User not found");
    }
    if (response.passWord != user.passWord) {
      throw Exception("Invalid Username/Password");
    }
    await CartSecureStore.setSecureStore(
        CartSecureStore.userName, response.userName);
    await CartSecureStore.setSecureStore(
        CartSecureStore.profile, response.profile);
    await CartSecureStore.setSecureStore(
        CartSecureStore.userId, response.userId.toString());

    return User.fromJson(response.toMap());
  }
}
