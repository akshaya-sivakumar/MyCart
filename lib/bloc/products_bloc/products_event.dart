part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class Fetchproducts extends ProductsEvent {
  final String category;

  Fetchproducts(this.category);
}

class ProductAddEvent extends ProductsEvent {
  final Product product;

  ProductAddEvent(this.product);
}

class ProductDeleteEvent extends ProductsEvent {
  final int productId;

  ProductDeleteEvent(this.productId);
}
