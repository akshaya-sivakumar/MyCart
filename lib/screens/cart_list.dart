import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycart/bloc/products_bloc/products_bloc.dart';

class CartList extends StatefulWidget {
  CartList({Key? key}) : super(key: key);

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  late ProductsBloc productsBloc;
  @override
  void initState() {
    super.initState();
    productsBloc = BlocProvider.of<ProductsBloc>(context);

    productsBloc.add(Fetchproducts());
  }

  List categories = ["Mobile", "AC", "Laptops", "Watch", "TV"];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add_shopping_cart),
            label: Text("Add item")),
        appBar: AppBar(
            title: const Text("Cart"),
            bottom: TabBar(
                isScrollable: true,
                tabs: List.generate(
                    5,
                    (index) => Tab(
                          text: categories[index],
                        )))),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          /*  buildWhen: (previous, current) {
            return current is ProductsDone;
          }, */
          builder: (context, ProductsState state) {
            if (state is ProductsLoad) {
              print("loading");
              return Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
            }
            if (state is ProductsDone) {
              print("done");
              return TabBarView(children: [
                ListView.builder(
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(state.products[index].title);
                    }),
                ListView.builder(
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(state.products[index].title);
                    }),
                ListView.builder(
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(state.products[index].title);
                    }),
                ListView.builder(
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(state.products[index].title);
                    }),
                ListView.builder(
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(state.products[index].title);
                    })
              ]);
            }
            print("error");
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ));
          },
        ),
      ),
    );
  }
}
