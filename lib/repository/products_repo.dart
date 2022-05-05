import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';

import 'package:mycart/model/products_model.dart';

class ProductsRepository {
  Future<List<Product>> data() async {
    final response = await rootBundle.loadString('lib/assets/products.json');

    List<Product> productsResponse =
        List.from(json.decode(response).map((e) => Product.fromJson(e)));

    return productsResponse;
  }
}
