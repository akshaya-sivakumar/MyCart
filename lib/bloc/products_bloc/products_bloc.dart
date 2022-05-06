import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mycart/model/products_model.dart';
import 'package:mycart/repository/products_repo.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial()) {
    on<Fetchproducts>((event, emit) async {
      emit(ProductsLoad());
      try {
        await Future.delayed(const Duration(milliseconds: 100));

        final products = await ProductsRepository().data(event.category);
        emit(ProductsDone(products));
      } catch (e) {
        emit(ProductsError());
      }
    });
    on<ProductAddEvent>((event, emit) async {
      await ProductsRepository().addProduct(event.product);
      emit(ProductsAdded());
    });
    on<ProductDeleteEvent>((event, emit) async {
      await ProductsRepository().deleteProduct(event.productId);
      emit(ProductsDeleted());
    });
  }
}
