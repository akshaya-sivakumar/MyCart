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
        final products = await ProductsRepository().data();
        emit(ProductsDone(products));
      } catch (e) {
        emit(ProductsError());
      }
    });
  }
}
