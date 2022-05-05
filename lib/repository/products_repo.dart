import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';

import 'package:mycart/model/products_model.dart';
import 'package:mycart/model/sqlite/sqlite_model.dart';

class ProductsRepository {
  Future<List<Product>> data() async {
    final response = await SqlProducts().select().toList();

    List<Product> productsResponse = List.from(
        response.map((e) => Product.fromJson(json.decode(e.toJson()))));

    return productsResponse;
  }

  Future<Product> addProduct(Product product) async {
    final response = await SqlProducts.fromMap(product.toJson()).upsert();

    var productResponse = await SqlProducts().select().toList();
    print(productResponse.last.toMap());
    return Product.fromJson(productResponse.last.toMap());
  }
}
