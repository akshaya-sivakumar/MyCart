import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import 'dart:convert';

part 'sqlite_model.g.dart';

@SqfEntityBuilder(cart)
const SqfEntityModel cart = SqfEntityModel(
    modelName: null,
    databaseName: 'cart.db',
    databaseTables: [tableUser, tableProducts],
    sequences: null,
    bundledDatabasePath: null);
const SqfEntityTable tableUser = SqfEntityTable(
    tableName: 'user',
    primaryKeyName: 'userId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: "SqlUser",
    fields: [
      SqfEntityField('userName', DbType.text),
      SqfEntityField('passWord', DbType.text),
      SqfEntityField('profile', DbType.text),
      SqfEntityField('dateOfBirth', DbType.text),
    ]);

const SqfEntityTable tableProducts = SqfEntityTable(
    tableName: 'products',
    primaryKeyName: 'productId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: "SqlProducts",
    fields: [
      SqfEntityField('userId', DbType.text),
      SqfEntityField('orderId', DbType.text),
      SqfEntityField('categoryName', DbType.text),
      SqfEntityField('productName', DbType.text),
      SqfEntityField('modelNumber', DbType.text),
      SqfEntityField('price', DbType.text),
      SqfEntityField('description', DbType.text),
      SqfEntityField('manufactureDate', DbType.text),
      SqfEntityField('manufactureAddress', DbType.text),
    ]);
