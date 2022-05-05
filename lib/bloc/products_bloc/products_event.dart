part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class Fetchproducts extends ProductsEvent {}

class ProductAddEvent extends ProductsEvent {
  final Product product;

  ProductAddEvent(this.product);
}
