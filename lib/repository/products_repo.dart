import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';

import 'package:mycart/model/products_model.dart';
import 'package:mycart/model/sqlite/sqlite_model.dart';

import '../resources/utilities/cart_secure_store.dart';

class ProductsRepository {
  Future<List<Product>> data(String category) async {
    String userId =
        await CartSecureStore.getSecureStore(CartSecureStore.userId);
    final response =
        await SqlProducts().select().userId.equals(userId).toList();

    List<Product> productsResponse = List.from(
        response.map((e) => Product.fromJson(json.decode(e.toJson()))));

    return productsResponse
        .where((element) => element.category == category)
        .toList();
  }

  Future<Product> addProduct(Product product) async {
    product.userId =
        await CartSecureStore.getSecureStore(CartSecureStore.userId);
    final response = await SqlProducts.fromMap(product.toJson()).upsert();

    var productResponse = await SqlProducts().select().toList();
    print(productResponse.last.toMap());
    return Product.fromJson(productResponse.last.toMap());
  }

  deleteProduct(int productId) async {
    await SqlProducts().select().productId.equals(productId).delete();
  }
}
