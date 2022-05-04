part of 'products_bloc.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoad extends ProductsState {}

class ProductsDone extends ProductsState {
  final List<Products> products;

  ProductsDone(this.products);
}
