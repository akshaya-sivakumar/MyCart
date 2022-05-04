import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';

import 'package:mycart/model/products_model.dart';

class ProductsRepository {
  Future<List<Products>> data() async {
    final response = await rootBundle.loadString('lib/assets/products.json');

    List<Products> productsResponse =
        List.from(json.decode(response).map((e) => Products.fromJson(e)));

    return productsResponse;
  }
}
